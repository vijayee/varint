use "ponytest"

primitive Varint
  fun encodeZigZag (num: U64, bits: USize) : U64 =>
    (num << 1) xor (num >> (bits.u64() - 1))

  fun decodeZigZag (num: U64, bits: USize) : I64 =>
    if ((num and 0x1) == 0x1) then
      -1 * ((num >> 1).i64() + 1)
    else
      (num - 1).i64()
    end
    
  fun encode (num': U64, out: Array[U8] ref = [], offset': USize = 0): Array[U8] ref ? =>
      var num = num'
      var offset : USize = offset'

      while (num >= 0x80000000) do // While greater than 32 bits of precision
        if ((offset + 1) >= out.size()) then
          offset = offset + 1
          out.push(((num and 0xFF) or 0x80).u8())
        else
          out(offset = offset + 1)? = ((num and 0xFF) or 0x80).u8()
        end
        num = num / 128
      end

      while ((num.i64() and -0x80) != 0) do
        if ((offset + 1)  >= out.size()) then
          offset = offset + 1
          out.push(((num and 0xFF) or 0x80).u8())
        else
          out(offset = offset + 1)? = ((num and 0xFF) or 0x80).u8()
        end
        num = num >> 7
      end

      if ((offset + 1)  >= out.size()) then
        offset = offset + 1
        out.push((num or 0).u8())
      else
        out(offset)? = (num or 0).u8()
      end
      out

  fun decode (data: Array[U8], offset': USize = 0) : U64 ? =>
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
        (byte.u64() and 0x7F) << shift
      else
        (byte.u64() and 0x7F) * F64(2).pow(shift.f64()).u64()
      end
      shift = shift + 7
    until byte.u64() < 0x80 end
    out
