# -*- coding: binary -*-
module StructFu
  # Int32le is a four byte value in little-endian format. The endianness cannot be altered.
  class Int32le < Int32
    undef :endian=
    def initialize(v=nil, e=:little)
      super(v,e)
    end
  end
end
