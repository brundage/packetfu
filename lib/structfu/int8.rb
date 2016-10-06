# -*- coding: binary -*-
module StructFu
  # Int8 is a one byte value.
  class Int8 < Int

    def initialize(v=nil)
      super(v,nil,w=1)
      @packstr = "C"
    end

    # Returns a one byte value as a packed string.
    def to_s
     [(self.v || self.d)].pack("C")
    end

  end
end
