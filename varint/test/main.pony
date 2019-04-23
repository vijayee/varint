use "ponytest"
use ".."
use "random"
use "time"

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)
  new make () =>
    None
  fun tag tests(test: PonyTest) =>
    test(_Test300)
    test(_TestRandomInt)
    test(_TestOneByte)

class iso _Test300 is UnitTest
  fun name(): String => "Testing encode 300"
  fun apply(t: TestHelper) =>
    let buf: Array[U8] = [172; 2]
    try
      let num: U64 = Varint.decode(buf)?
      t.assert_true(num == 300)
      let enc: Array[U8] = Varint.encode(300)?
      t.assert_array_eq[U8](enc, buf)
    else
      t.fail("Error")
      t.complete(true)
    end

class iso _TestRandomInt is UnitTest
  fun name(): String => "Testing encode/decode random int"
  fun apply(t: TestHelper) =>
    let now = Time.now()
    var gen = Rand(now._1.u64(), now._2.u64())
    try
      let num: U64 = gen.u64()
      let enc: Array[U8] = Varint.encode(num)?
      let dec: U64 = Varint.decode(enc)?
      t.assert_true(num == dec)
    else
      t.fail("Error")
      t.complete(true)
    end

class iso _TestOneByte is UnitTest
  fun name(): String => "Testing encoding/decoding one byte"
  fun apply(t: TestHelper) =>
    let now = Time.now()
    var gen = Rand(now._1.u64(), now._2.u64())
    try
      let num: U64 = gen.u8().u64()
      let enc: Array[U8] = Varint.encode(num)?
      let dec: U64 = Varint.decode(enc)?
      t.assert_true(num == dec)
    else
      t.fail("Error")
      t.complete(true)
    end
/*
class iso _TestZeroByte is UnitTest
  fun name(): String => "Testing encoding/decoding with leading Zeroes byte"
  fun apply(t: TestHelper) =>
    let now = Time.now()
    var gen = Rand(now._1.u64(), now._2.u64())
    try
      let buf: Array[U8] = [0; gen.u8()]
      let num: U64 = Varint.decode(buf, t)?
      t.assert_true(num == 300)
      let enc: Array[U8] = Varint.encode(300, t)?
      t.assert_array_eq[U8](enc, buf)
    else
      t.fail("Error")
      t.complete(true)
    end
*/
