This test case reveals an issue in server side profiling.

Issue: Profiles saved in memory and in files have different headers. Profiles saved in memory cannot be parsed
by viewer.   
Code with the issue: https://github.com/eluck/tracing-framework/tree/70b4bfa916bb9ecd988655e47088a3c6fdd8483b/test/eluck/testcase2   

A workaround for the issue is found: update header of a snapshot saved into a buffer.   
Commit with workaround: https://github.com/eluck/tracing-framework/commit/7e056c523ff8dc7d619b1559ecc38ed6de7f0019   

How to run the testcase:
  1. Launch this script "node main.js"
  2. The script will create two snapshots: the first one - correct - will be saved into a file, the second - broken - will be saved into a memory buffer and then flushed to disk
  3. The second snapshot is broken and cannot be loaded by viewer (its header is invalid, however the body is ok)
