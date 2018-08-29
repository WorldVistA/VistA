# ---------------------------------------------------------------------------
# Copyright 2018 The Open Source Electronic Health Record Alliance
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
# ---------------------------------------------------------------------------

import argparse
import filecmp
import os
import sys
import unittest

import ICRParser

from InitCrossReferenceGenerator import createInitialCrossRefGenArgParser

EXPECTED_PDFS = {
    "General_Medical_Record___Vitals": ["ICR-3996.pdf"],
    "Imaging": ["ICR-4528.pdf"],
    "Lab_Service": ["ICR-6104.pdf", "ICR-91.pdf"],
    "Mental_Health": ["ICR-1068.pdf"],
    "Registration": ["ICR-4849.pdf"],
    "Text_Integration_Utility": ["ICR-3248.pdf", "ICR-5499.pdf"],
    "IFCAP": ["ICR-214.pdf"],
    "Kernel": ["ICR-10156.pdf", "ICR-977.pdf"],
    "MailMan": ["ICR-1151.pdf"],
    "Record_Tracking": ["ICR-85.pdf"],
    "Surgery": ["ICR-16.pdf", "ICR-6730.pdf"],
    "VA_FileMan": ["ICR-10155.pdf"]}


class testICRParser(unittest.TestCase):
    def test_01_json(self):
        generated_output_dir = os.path.join(args.testOutDir, "JSON")
        generated_icr_json = os.path.join(generated_output_dir, "ICRTest.JSON")
        ICRParser.generate_json(TEST_ICR_FILE, generated_icr_json)

        # Check that expected JSON was generated
        self.assertTrue(filecmp.cmp(TEST_ICR_JSON, generated_icr_json))

        # Make sure ONLY JSON file was generated
        generated_files = os.listdir(generated_output_dir)
        self.assertEqual(len(generated_files), 1)

        # TODO: Remove generated_output_dir?

    def test_02_html(self):
        generated_output_dir = os.path.join(args.testOutDir, "HTML")
        generated_icr_output_dir = os.path.join(generated_output_dir, "ICR")
        generated_icr_json = os.path.join(generated_output_dir, "ICRTest.JSON")
        ICRParser.generate_html(TEST_ICR_FILE, generated_icr_json, args.MRepositDir,
                                args.patchRepositDir, generated_icr_output_dir)

        # Check that expected HTML files were generated
        generated_files = os.listdir(generated_icr_output_dir)
        generated_files.sort()
        self.assertEqual(TEST_ICR_FILES, generated_files)
        # And that they contain the expected content
        for f in TEST_ICR_FILES:
            expected_file = os.path.join(TEST_ICR_DIR, f)
            generated_file = os.path.join(generated_icr_output_dir, f)
            if not filecmp.cmp(expected_file, generated_file):
                self.fail("%s is not the same as %s" % (expected_file, generated_file))

        # TODO: Remove generated_output_dir?

    def test_03_pdf(self):
        generated_output_dir = os.path.join(args.testOutDir, "PDF")
        generated_pdf_output_dir = os.path.join(generated_output_dir, "dox", "PDF")
        generated_icr_json = os.path.join(generated_output_dir, "ICRTest.JSON")
        ICRParser.generate_pdf(TEST_ICR_FILE, generated_icr_json, args.MRepositDir,
                               args.patchRepositDir, generated_pdf_output_dir)

        # Check that expected subdirectories were generated
        expected_dirs = EXPECTED_PDFS.keys()
        expected_dirs.sort()
        generated_dirs = os.listdir(generated_pdf_output_dir)
        generated_dirs.sort()
        self.assertEqual(expected_dirs, generated_dirs)
        # Check that expected PDFS were generated
        # Note: Content is NOT checked
        for pdf_dir in expected_dirs:
            expected_files = EXPECTED_PDFS[pdf_dir]
            expected_files.sort()
            generated_files = os.listdir(os.path.join(generated_pdf_output_dir, pdf_dir))
            generated_files.sort()
            self.assertEqual(expected_files, generated_files)

        # TODO: Remove generated_output_dir?

    def test_04_all(self):
        generated_output_dir = os.path.join(args.testOutDir, "ALL")
        generated_icr_output_dir = os.path.join(generated_output_dir, "ICR")
        generated_icr_json = os.path.join(generated_output_dir, "ICRTest.JSON")
        generated_pdf_output_dir = os.path.join(generated_output_dir, "dox", "PDF")
        ICRParser.generate_all(TEST_ICR_FILE, generated_icr_json, args.MRepositDir,
                               args.patchRepositDir, generated_icr_output_dir,
                               generated_pdf_output_dir)

        # Check that expected HTML files were generated
        generated_html_files = os.listdir(generated_icr_output_dir)
        generated_html_files.sort()
        self.assertEqual(TEST_ICR_FILES, generated_html_files)
        # And that they contain the expected content
        for f in TEST_ICR_FILES:
            expected_file = os.path.join(TEST_ICR_DIR, f)
            generated_file = os.path.join(generated_icr_output_dir, f)
            if not filecmp.cmp(expected_file, generated_file):
                self.fail("%s is not the same as %s" % (expected_file, generated_file))

        # Check that expected subdirectories were generated
        expected_pdf_dirs = EXPECTED_PDFS.keys()
        expected_pdf_dirs.sort()
        generated_pdf_dirs = os.listdir(generated_pdf_output_dir)
        generated_pdf_dirs.sort()
        self.assertEqual(expected_pdf_dirs, generated_pdf_dirs)
        # Check that expected PDFS were generated
        # Note: Content is NOT checked
        for pdf_dir in expected_pdf_dirs:
            expected_pdf_files = EXPECTED_PDFS[pdf_dir]
            expected_pdf_files.sort()
            generated_pdf_files = os.listdir(os.path.join(generated_pdf_output_dir, pdf_dir))
            generated_pdf_files.sort()
            self.assertEqual(expected_pdf_files, generated_pdf_files)

        # TODO: Remove generated_output_dir?

    def test_05_local(self):
        pass


if __name__ == '__main__':
    init_parser = createInitialCrossRefGenArgParser()
    parser = argparse.ArgumentParser(description='VistA ICR Parser',
                                     parents=[init_parser])
    parser.add_argument('testOutDir', help='Test files will be created here')
    args = parser.parse_args()

    # Require that output directory is empty
    if os.path.exists(args.testOutDir) and os.path.isdir(args.testOutDir):
        if os.listdir(args.testOutDir):
            sys.exit("Test output directory must be empty")

    scripts_dir = os.path.join(args.patchRepositDir, "Utilities", "Dox", "PythonScripts")
    TEST_ICR_FILE = os.path.join(scripts_dir, "ICRTest.txt")
    TEST_ICR_JSON = os.path.join(scripts_dir, "ICRTest.JSON")
    TEST_ICR_DIR = os.path.join(scripts_dir, "ICR_TEST", "ICR")
    TEST_ICR_FILES = os.listdir(TEST_ICR_DIR)
    TEST_ICR_FILES.sort()

    suite = unittest.TestLoader().loadTestsFromTestCase(testICRParser)
    unittest.TextTestRunner(verbosity=2).run(suite)
