# -*- coding: binary -*-
module StructFu
  # Ints all have a value, an endianness, and a default value.
  # Note that the signedness of Int values are implicit as
  # far as the subclasses are concerned; to_i and to_f will 
  # return Integer/Float versions of the input value, instead
  # of attempting to unpack the pack value. (This can be a useful
  # hint to other functions).
  #
  # ==== Header Definition
  #
  #   Fixnum  :value
  #   Symbol  :endian
  #   Fixnum  :width
  #   Fixnum  :default
  class Int < Struct.new(:value, :endian, :width, :default)
    alias :v= :value=
    alias :v :value
    alias :e= :endian=
    alias :e :endian
    alias :w= :width=
    alias :w :width
    alias :d= :default=
    alias :d :default

    # This is a parent class definition and should not be used directly.
    def to_s
      raise StandardError, "#{self.class.name}#to_s accessed, must be redefined."
    end

    # Returns the Int as an Integer.
    def to_i
      (self.v || self.d).to_i
    end

    # Returns the Int as a Float.
    def to_f
      (self.v || self.d).to_f
    end
    
    def initialize(value=nil, endian=nil, width=nil, default=nil)
      super(value,endian,width,default=0)
    end

    # Reads either an Integer or a packed string, and populates the value accordingly.
    def read(i)
      self.v = i.kind_of?(Integer) ? i.to_i : i.to_s.unpack(@packstr).first
      self
    end

  end
end
