This test case reveals an issue in server side profiling.

Issue: All profiles after the first one are broken. 

How to run the testcase:
  1. Launch this script "node main.js"
  2. The script will create two trace files: the first one - correct, the second - broken (cannot be loaded by viewer)
