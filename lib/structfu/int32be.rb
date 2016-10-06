# -*- coding: binary -*-
module StructFu
  # Int32be is a four byte value in big-endian format. The endianness cannot be altered.
  class Int32be < Int32
    undef :endian=
  end
end
