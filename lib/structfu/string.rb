# -*- coding: binary -*-
module StructFu
  # Strings are just like regular strings, except it comes with a read() function
  # so that it behaves like other StructFu elements.
  class String < ::String
    def read(str)
      str = str.to_s
      self.replace str
      self
    end
  end
end
