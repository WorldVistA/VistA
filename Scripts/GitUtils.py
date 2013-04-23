#---------------------------------------------------------------------------
# Copyright 2013 The Open Source Electronic Health Record Agent
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
import os
import sys
import subprocess
import re
import argparse
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

def addChangeSet(gitRepoDir=None, patternList=None):
  """
    Utility function to add all the files changed to staging area
    @gitRepoDir: git repository directory, default is current directory.
                 if provided, will only add all changes under that directory
    @patternList: a list of pattern for matching files.
                  need to escape wildcard character '*'
    @return: return True if success, False otherwise
  """
  git_command_list = ["git", "add", "-A", "--"]
  if patternList and isinstance(patternList, list):
    git_command_list.extend(patternList)

  result, output = _runGitCommand(git_command_list, gitRepoDir)
  logger.info(output)
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
    return dict(zip(outfmtLst, output.strip('\r\n').split(delim)))
  return None

def _runGitCommand(gitCmdList, workingDir):
  """
    Private Utility function to run git command in subprocess
    @gitCmdList: a list of git commands to run
    @workingDir: the workding directory of the child process
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
      return (False, output)
    return (True, output)
  except OSError as ex:
    logger.error(ex)
  return (False, output)

def main():
  initConsoleLogging()
  pass

if __name__ == '__main__':
  main()
