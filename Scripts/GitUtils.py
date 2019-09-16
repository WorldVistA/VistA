#---------------------------------------------------------------------------
# Copyright 2013-2019 The Open Source Electronic Health Record Alliance
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#---------------------------------------------------------------------------
from builtins import zip
import codecs
import os
import sys
import subprocess
import re
import argparse
import difflib
from LoggerManager import logger, initConsoleLogging

""" Utilities Functions to wrap around git command functions via subprocess
    1. make sure git is accessible directly via command line,
       or git is in the %path% for windows or $PATH for Unix/Linux
"""

DEFAULT_GIT_HASH_LENGTH = 40 # default git hash length is 40

def getGitRepoRevisionHash(revision="HEAD", gitRepoDir=None):
  """
    Utility function to get the git hash based on a given git revision
    @revision: input revision, default is HEAD on the current branch
    @gitRepoDir: git repository directory, default is current directory.
    @return: return git hash if success, None otherwise
  """
  git_command_list = ["git", "rev-parse", "--verify", revision]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  if not result:
    return None
  lines = output.split('\r\n')
  for line in lines:
    line = line.strip(' \r\n')
    if re.search('^[0-9a-f]+$', line):
      return line
  return None

def commitChange(commitMsgFile, gitRepoDir=None):
  """
    Utility function to commit the change in the current branch
    @commitMsgFile: input commit message file for commit
    @gitRepoDir: git repository directory, default is current directory.
    @return: return True if success, False otherwise
  """
  if not os.path.exists(commitMsgFile):
    return False
  git_command_list = ["git", "commit", "-F", commitMsgFile]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  logger.info(output)
  return result

def addChangeSet(gitRepoDir=None, patternList=[]):
  """
    Utility function to add all the files changed to staging area
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @patternList: a list of pattern for matching files.
                  need to escape wildcard character '*'
    @return: return True if success, False otherwise
  """

  patternIncludeList = ["*.m"]
  for dir in os.listdir(gitRepoDir):
    git_command_list = ["git", "diff","--", "*.zwr"]
    result, output = _runGitCommand(git_command_list,os.path.join(gitRepoDir,dir))
    if not result:
      logger.error("Git DIFF command failed: " + output)
      raise Exception("Git DIFF command failed: " + output)
    test = output.split("\n")
    outLineStack = []
    results = []
    """
      Attempts to check each global file useful information in the diff.  It
      checks through the diff of each ZWR file.  If it finds a pair of addition
      and removal, it checks that the line change isn't just a date/time or
      number change.  If a file consists entirely of date/time changes, it is
      excluded from the added files.  A special case is made for the DEVICE file
      to eliminate the count of times that each DEVICE was opened.

      This assumes the script will be run in the "Packages" directory, which
      necessitates the removal of the "Packages/" string from the filename
    """
    currentFile=None
    skipNext=False
    for index, line in enumerate(test):
      if '.zwr' in line:
        if ("OK" in results) or len(outLineStack):
          patternIncludeList.append(currentFile)
        outLineStack = []
        currentFile = line[15:].strip()
        results = []
        continue
      if line.startswith("-"):
        outLineStack.append(line)
      elif line.startswith("+"):
        if len(outLineStack):
          diffStack=[]
          out = difflib.ndiff(line[1:].split("^"), outLineStack[0][1:].split("^"))
          outList = '**'.join(out).split("**")
          if len(outList) > 1:
            for i,s in enumerate(outList):
              if i == len(outList):
                results.append("OK")
                break
              if s:
                if s[0]=="-":
                  diffStack.append(s[2:])
                if s[0] == "+":
                  if len(diffStack):
                    if re.search("DIC\(9.8,",s[2:]):
                      break
                    if re.search("[0-9]{7}(\.[0-9]{4,6})*",s[2:]) or re.search("[0-9]{7}(\.[0-9]{4,6})*",diffStack[0]):
                      results.append("DATE")
                      break
                    if re.search("[0-9]{2}\-[A-Z]{3}\-[0-9]{4}",s[2:]) or re.search("[0-9]{2}\:[0-9]{2}\:[0-9]{2}",diffStack[0]) :
                      results.append("DATE")
                      break
                    if re.search("[0-9]{2}:[0-9]{2}:[0-9]{2}",s[2:]) or re.search("[0-9]{2}\:[0-9]{2}\:[0-9]{2}",diffStack[0]) :
                      results.append("DATE")
                      break
                    # Removes a specific global entry in DEVICE file which maintains a count of the times the device was opened
                    if re.search("%ZIS\([0-9]+,[0-9]+,5",s[2:]):
                      break
                    diffStack.pop(0)
            outLineStack.pop(0)
        else:
          results.append("OK")
  """ Now add everything that can be found or was called for"""
  git_command_list = ["git", "add", "--"]
  totalIncludeList = patternList + patternIncludeList
  for file in totalIncludeList:
    git_command = git_command_list + [file]
    result, output = _runGitCommand(git_command, gitRepoDir)
    if not result:
      logger.error("Git add command failed: " + output)
      raise Exception("Git add command failed: " + output)
  logger.info(output)
  """ Add the untracked files through checking for "other" files and
  then add the list
  """
  git_command = ["git","ls-files","-o","--exclude-standard"]
  result, lsFilesOutput = _runGitCommand(git_command, gitRepoDir)
  git_command_list = ["git","add"]
  for file in lsFilesOutput.split("\n"):
    if len(file):
      git_command = git_command_list + [file]
      result, output = _runGitCommand(git_command, gitRepoDir)
      if not result:
        logger.error("Git ls-files command failed: " + output)
        raise Exception("Git ls-files command failed: " + output)
  return result

def switchBranch(branchName, gitRepoDir=None):
  """
    Utility function to switch to a different branch
    @branchName: the name of the branch to switch to
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @return: return True if success, False otherwise
  """
  git_command_list = ["git", "checkout", branchName]
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  logger.info(output)
  return result

def getStatus(gitRepoDir=None, subDirPath=None):
  """
    Utility function to report git status on the directory
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @subDirPath: report only the status for the subdirectory provided
    @return: return the status message
  """
  git_command_list = ["git", "status"]
  if subDirPath:
    git_command_list.extend(['--', subDirPath])
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  return output

def getCommitInfo(gitRepoDir=None, revision='HEAD'):
  """
    Utility function to retrieve commit information
    like date/time in Unix timestamp, title and hash
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only report info WRT to git repository
    @revision: the revision to retrieve info, default is HEAD
    @return: return commit info dictionary
  """
  delim = '\n'
  outfmtLst = ("%ct","%s","%H")
  git_command_list = ["git", "log"]
  fmtStr = "--format=%s" % delim.join(outfmtLst)
  git_command_list.extend([fmtStr, "-n1", revision])
  result, output = _runGitCommand(git_command_list, gitRepoDir)
  if result:
    return dict(list(zip(outfmtLst, output.strip('\r\n').split(delim))))
  return None

def _runGitCommand(gitCmdList, workingDir):
  """
    Private Utility function to run git command in subprocess
    @gitCmdList: a list of git commands to run
    @workingDir: the working directory of the child process
    @return: return a tuple of (True, output) if success,
             (False, output) otherwise
  """
  output = None
  try:
    popen = subprocess.Popen(gitCmdList,
                             cwd=workingDir, # set child working directory
                             stdout=subprocess.PIPE)
    output = popen.communicate()[0]
    if popen.returncode != 0: # command error
      return (False, codecs.decode(output,'utf-8','ignore'))
    return (True, codecs.decode(output, 'utf-8', 'ignore'))
  except OSError as ex:
    logger.error(ex)
  return (False, codecs.decode(output, 'utf-8', 'ignore'))

def main():
  initConsoleLogging()
  pass

if __name__ == '__main__':
  main()
