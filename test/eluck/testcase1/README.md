This test case reveals an issue in server side profiling.

Issue: All profiles after the first one are broken.   
Code with the issue: https://github.com/eluck/tracing-framework/tree/70b4bfa916bb9ecd988655e47088a3c6fdd8483b/test/eluck/testcase1   

The issue is fixed by removing wtf object from CommonJS cache.   
Commit with fix: https://github.com/eluck/tracing-framework/commit/3e9973d6f1b7049d5a8cb8e30f0b7b60b29dc573   
Commit with updated testcase code: https://github.com/eluck/tracing-framework/commit/d30e5e48f7dff29818237388a8381116fce2e17b   

How to run the testcase:
  1. Launch this script "node main.js"
  2. The script will create two trace files: the first one - correct, the second - broken (cannot be loaded by viewer)
