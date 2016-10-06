# -*- coding: binary -*-
module StructFu
  # Int64 is a eight byte value.
  class Int64 < Int
    def initialize(v=nil, e=:big)
      super(v, e, w=4)
      @packstr = (self.e == :big) ? 'Q>' : 'Q<'
    end

    # Returns a eight byte value as a packed string.
    def to_s
      @packstr = (self.e == :big) ? 'Q>' : 'Q<'
      [(self.v || self.d)].pack(@packstr)
    end
  end
end
