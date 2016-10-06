# -*- coding: binary -*-
module PacketFu
  # The Timestamp class defines how Timestamps appear in libpcap files.
  #
  # ==== Header Definition
  #
  #  Symbol  :endian  Default: :little
  #  Int32   :sec
  #  Int32   :usec
  class Timestamp < Struct.new(:endian, :sec, :usec)
    include StructFu

    def initialize(args={})
      set_endianness(args[:endian] ||= :little)
      init_fields(args)
      super(args[:endian], args[:sec], args[:usec])
    end

    # Called by initialize to set the initial fields. 
    def init_fields(args={})
      args[:sec] = @int32.new(args[:sec])
      args[:usec] = @int32.new(args[:usec])
      return args
    end

    # Returns the object in string form.
    def to_s
      self.to_a[1,2].map {|x| x.to_s}.join
    end

    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      self[:sec].read str[0,4]
      self[:usec].read str[4,4]
      self
    end

  end
end
