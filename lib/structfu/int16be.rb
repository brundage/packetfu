# -*- coding: binary -*-
module StructFu
  # Int16be is a two byte value in big-endian format. The endianness cannot be altered.
  class Int16be < Int16
    undef :endian=
  end
end
