# -*- coding: binary -*-
module StructFu
  # Int64le is a eight byte value in little-endian format. The endianness cannot be altered.
  class Int64le < Int64
    undef :endian=
    def initialize(v=nil, e=:little)
      super(v,e)
    end
  end
end
