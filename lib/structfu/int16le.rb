# -*- coding: binary -*-
module StructFu
  # Int16le is a two byte value in little-endian format. The endianness cannot be altered.
  class Int16le < Int16
    undef :endian=
    def initialize(v=nil, e=:little)
      super(v,e)
      @packstr = (self.e == :big) ? "n" : "v"
    end
  end
end
