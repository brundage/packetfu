# -*- coding: binary -*-
module StructFu
  # Int16 is a two byte value.
  class Int16 < Int
    def initialize(v=nil, e=:big)
      super(v,e,w=2)
      @packstr = (self.e == :big) ? "n" : "v"
    end

    # Returns a two byte value as a packed string.
    def to_s
      @packstr = (self.e == :big) ? "n" : "v"
      [(self.v || self.d)].pack(@packstr)
     end

  end
end
