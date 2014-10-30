console.log 'This test case reveals an issue in server side profiling.\n',
'  The issue: Profiles saved in memory and in files have different headers. Profiles saved in memory cannot
    be parsed by viewer.\n',
'  How to run the testcase:\n',
'    1. Launch this script "node main.js"\n',
'    2. The script will create two snapshots: the first one - correct - will be saved into a file, the second -
       broken - will be saved into a memory buffer and then flushed to disk\n',
'    3. The second snapshot is broken and cannot be loaded by viewer (its header is invalid, however the body is ok)\n'

root = '../../..'
wtf = require("#{root}/build-out/wtf_node_js_compiled")
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



testcase('testcase1')
saveSnapshotToDrive('testcase1')
buffer = saveSnapshotToBuffer()
setTimeout ->
    flushBufferToDrive(buffer, 'testcase2')
    wtf.trace.stop()
    setTimeout ->
      wtf.trace.stop()
      console.log('exiting normally')
      process.exit(0)
    , 5000
, 5000
