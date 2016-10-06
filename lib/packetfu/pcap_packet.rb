# -*- coding: binary -*-
module PacketFu
  # PcapPacket defines how individual packets are stored in a libpcap-formatted
  # file.
  #
  # ==== Header Definition
  #
  # Timestamp  :timestamp
  # Int32      :incl_len
  # Int32      :orig_len
  # String     :data
  class PcapPacket < Struct.new(:endian, :timestamp, :incl_len,
                               :orig_len, :data)
    include StructFu
    def initialize(args={})
      set_endianness(args[:endian] ||= :little)
      init_fields(args)
      super(args[:endian], args[:timestamp], args[:incl_len],
           args[:orig_len], args[:data])
    end

    # Called by initialize to set the initial fields. 
    def init_fields(args={})
      args[:timestamp] = Timestamp.new(:endian => args[:endian]).read(args[:timestamp])
      args[:incl_len] = args[:incl_len].nil? ? @int32.new(args[:data].to_s.size) : @int32.new(args[:incl_len])
      args[:orig_len] = @int32.new(args[:orig_len])
      args[:data] = StructFu::String.new.read(args[:data])
    end

    # Returns the object in string form.
    def to_s
      self.to_a[1,4].map {|x| x.to_s}.join
    end

    # Reads a string to populate the object.
    def read(str)
      return unless str
      force_binary(str)
      self[:timestamp].read str[0,8]
      self[:incl_len].read str[8,4]
      self[:orig_len].read str[12,4]
      self[:data].read str[16,self[:incl_len].to_i]
      self
    end

  end
end
