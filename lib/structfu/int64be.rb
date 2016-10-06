# -*- coding: binary -*-
module StructFu
  # Int64be is a eight byte value in big-endian format. The endianness cannot be altered.
  class Int64be < Int64
    undef :endian=
  end
end
