console.log 'This test case reveals an issue in server side profiling.\n',
'  Issue: All profiles after the first one are broken.\n',
'\n',
'  The issue is fixed by removing wtf object from CommonJS cache.\n',
'  Commit with fix: https://github.com/eluck/tracing-framework/commit/3e9973d6f1b7049d5a8cb8e30f0b7b60b29dc573\n',
'  Commit with updated testcase code: https://github.com/eluck/tracing-framework/commit/d30e5e48f7dff29818237388a8381116fce2e17b\n',
'\n',
'  How to run the testcase:\n',
'    1. Launch this script "node main.js"\n',
'    2. The script will create two trace files: the first one - correct, the second -
       broken (cannot be loaded by viewer)\n'

root = '../../..'
getNewWTF = require("#{root}/build-out/wtf_node_js_compiled")
wtf = {}
randomToken = require('crypto').randomBytes(8).toString('hex');

testcase = (name) ->
  wtf = getNewWTF()
  console.log("running #{name}")
  wtf.trace.prepare()
  wtf.trace.start()
  scope = wtf.trace.enterScope name
  for n in [0..100000000]
    do ->
  wtf.trace.leaveScope(scope)
  snapshotName = "#{__dirname}/#{name}_#{randomToken}.wtf-trace"
  console.log("saving snapshot: #{snapshotName}")
  wtf.trace.snapshot("file://#{snapshotName}")



testcase('testcase1')
setTimeout ->
    wtf.trace.stop()
    testcase('testcase2')
    setTimeout ->
      wtf.trace.stop()
      console.log('exiting normally')
      process.exit(0)
    , 5000
, 5000
