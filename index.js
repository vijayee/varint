const varint = require('varint')

let buf = new Uint8Array(2)
buf[0] = 172
buf[1] = 2
let num = varint.decode(buf)
console.log(`decoded ${num}`)
console.log(varint.encode(17930761431275729678))
