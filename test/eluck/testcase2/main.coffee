console.log 'This test case reveals an issue in server side profiling.\n',
'  Issue: Profiles saved in memory and in files have different headers. Profiles saved in memory cannot
    be parsed by viewer.\n',
'  Code with the issue: https://github.com/eluck/tracing-framework/tree/70b4bfa916bb9ecd988655e47088a3c6fdd8483b/test/eluck/testcase2\n',
'\n',
'  A workaround for the issue is found: update header of a snapshot saved into a buffer.\n',
'  Commit with workaround: https://github.com/eluck/tracing-framework/commit/7e056c523ff8dc7d619b1559ecc38ed6de7f0019\n',
'\n',
'  How to run the testcase:\n',
'    1. Launch this script "node main.js"\n',
'    2. The script will create two snapshots: the first one - correct - will be saved into a file, the second -
       broken - will be saved into a memory buffer and then flushed to disk\n',
'    3. The second snapshot is broken and cannot be loaded by viewer (its header is invalid, however the body is ok)\n'

root = '../../..'
wtf = require("#{root}/build-out/wtf_node_js_compiled")()
randomToken = require('crypto').randomBytes(8).toString('hex');


testcase = (name) ->
  console.log("running testcase")
  wtf.trace.node.start()
  scope = wtf.trace.enterScope name
  for n in [0..100000000]
    do ->
  wtf.trace.leaveScope(scope)


saveSnapshotToDrive = (name) ->
  snapshotName = "#{__dirname}/#{name}_#{randomToken}.wtf-trace"
  console.log("saving snapshot: #{snapshotName}")
  wtf.trace.snapshot("file://#{snapshotName}")


saveSnapshotToBuffer = ->
  array = []
  console.log("saving snapshot to buffer")
  wtf.trace.snapshot(array)
  return array[0].buffer_


flushBufferToDrive = (buffer, name) ->
  snapshotName = "#{__dirname}/#{name}_#{randomToken}.wtf-trace"
  console.log("flushing buffer to file: #{snapshotName}")
  require('fs').writeFileSync(snapshotName, buffer)


fixBuffer = (buffer) ->
  for value, index in [0xef, 0xbe, 0xad, 0xde, 0x00, 0x44, 0x21, 0xe8, 0x0a, 0x00, 0x00, 0x00]
    buffer[index] = value



testcase('testcase1')
#saveSnapshotToDrive('testcase1')
buffer = saveSnapshotToBuffer()
setTimeout ->
    fixBuffer(buffer)
    flushBufferToDrive(buffer, 'testcase2')
    wtf.trace.stop()
    setTimeout ->
      console.log('exiting normally')
      process.exit(0)
    , 5000
, 5000
