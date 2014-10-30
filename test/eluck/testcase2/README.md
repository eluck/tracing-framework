This test case reveals an issue in server side profiling.

The issue: Profiles saved in memory and in files have different headers. Profiles saved in memory cannot be parsed
by viewer.

How to run the testcase:
  1. Launch this script "node main.js"
  2. The script will create two snapshots: the first one - correct - will be saved into a file, the second - broken - will be saved into a memory buffer and then flushed to disk
  3. The second snapshot is broken and cannot be loaded by viewer (its header is invalid, however the body is ok)
