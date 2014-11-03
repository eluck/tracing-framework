console.log 'This test case reveals an issue in server side profiling.\n',
'  The issue: All profiles after the first one are broken.\n',
'  How to run the testcase:\n',
'    1. Launch this script "node main.js"\n',
'    2. The script will create two trace files: the first one - correct, the second -
       broken (cannot be loaded by viewer)\n'

root = '../../..'
wtf = require("#{root}/build-out/wtf_node_js_compiled")
randomToken = require('crypto').randomBytes(8).toString('hex');

testcase = (name) ->
  console.log("running #{name}")
  wtf.trace.node.start()
  scope = wtf.trace.enterScope name
  for n in [0..100000000]
    do ->
  wtf.trace.leaveScope(scope)
  console.log("saving snapshot to buffer")
  array = []
  wtf.trace.snapshot(array)
  snapshotName = "#{__dirname}/#{name}_#{randomToken}.wtf-trace"
  console.log("flushing snapshot to file: #{snapshotName}")
  buffer = fixBuffer(array[0].buffer_)
  require('fs').writeFileSync(snapshotName, buffer)



fixBuffer = (buffer) ->
  for value, index in [0xef, 0xbe, 0xad, 0xde, 0x00, 0x44, 0x21, 0xe8, 0x0a, 0x00, 0x00, 0x00]
    console.log(buffer[index])
    buffer[index] = value
    console.log(buffer[index])
    console.log('')
  buffer


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
