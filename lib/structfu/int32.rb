# -*- coding: binary -*-
module StructFu
  # Int32 is a four byte value.
  class Int32 < Int
    def initialize(v=nil, e=:big)
      super(v,e,w=4)
      @packstr = (self.e == :big) ? "N" : "V"
    end

    # Returns a four byte value as a packed string.
    def to_s
      @packstr = (self.e == :big) ? "N" : "V"
      [(self.v || self.d)].pack(@packstr)
     end

  end
end
