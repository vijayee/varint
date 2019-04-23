use "ponytest"

primitive Varint
  fun msb (): U8 =>
    U8(0x80)
  fun rest () : U8 =>
    U8(0x7F)
  fun msball() : I64 =>
    I64(-0x80)//(not Varint.rest()).i8()
  fun int() :  U64 =>
    U64(2147483648)
  fun encode (num': U64, t: TestHelper, out: Array[U8] ref = [], offset': USize = 0): Array[U8] ref ? =>
      var num = num'
      var offset : USize = offset'
      t.log((num >= Varint.int()).string())
      while (num >= Varint.int()) do // While greater than 32 bits of precision
        if (offset >= (out.size() - 1)) then
          offset = offset + 1
          out.push((num.u8() and 0xFF) or Varint.msb())
        else
          out(offset = offset + 1)? = (num.u8() and 0xFF) or Varint.msb()
        end
        num = num / 128
      end

      while ((num.i64() and Varint.msball()) != 0) do
        t.log(((offset + 1) >= out.size()).string())
        if ((offset + 1)  >= out.size()) then
          offset = offset + 1
          out.push((num.u8() and 0xFF) or Varint.msb())
        else
          out(offset = offset + 1)? = (num.u8() and 0xFF) or Varint.msb()
        end
        num = num >> 7
        t.log(num.string())
      end

      if ((offset + 1)  >= out.size()) then
        offset = offset + 1
        out.push(num.u8() or 0)
      else
        out(offset)? = (num.u8() or 0)
      end
      out

  fun decode (data: Array[U8], t: TestHelper, offset': USize = 0) : U64 ? =>
    var offset: USize = offset'
    var shift: U64 = 0
    var out: U64 = 0
    var i: USize = offset
    var byte: U8 = 0
    var size = data.size()

    repeat
      if (i >= size) then
        error
      end

      byte = data(i = i + 1)?
      out = out + if (shift < 28) then
        (byte and Varint.rest()).u64() << shift
      else
        (byte and Varint.rest()).u64() * F64(2).pow(shift.f64()).u64()
      end
      shift = shift + 7
    until byte < Varint.msb() end
    out
