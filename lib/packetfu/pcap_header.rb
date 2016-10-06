# -*- coding: binary -*-
module PacketFu

  # PcapHeader represents the header portion of a libpcap file (the packets
  # themselves are in the PcapPackets array). See 
  # http://wiki.wireshark.org/Development/LibpcapFileFormat for details.
  #
  # Depending on the endianness (set with :endian), elements are either
  # :little endian or :big endian. 
  #
  # ==== PcapHeader Definition
  #
  #   Symbol  :endian     Default: :little
  #   Int32   :magic      Default: 0xa1b2c3d4 # :big is 0xd4c3b2a1
  #   Int16   :ver_major  Default: 2
  #   Int16   :ver_minor  Default: 4
  #   Int32   :thiszone
  #   Int32   :sigfigs
  #   Int32   :snaplen    Default: 0xffff
  #   Int32   :network    Default: 1
  class PcapHeader < Struct.new(:endian, :magic, :ver_major, :ver_minor,
                                :thiszone, :sigfigs, :snaplen, :network)
    include StructFu

    MAGIC_INT32  = 0xa1b2c3d4
    MAGIC_LITTLE = [MAGIC_INT32].pack("V")
    MAGIC_BIG    = [MAGIC_INT32].pack("N")

    def initialize(args={})
      set_endianness(args[:endian] ||= :little)
      init_fields(args) 
      super(args[:endian], args[:magic], args[:ver_major], 
            args[:ver_minor], args[:thiszone], args[:sigfigs], 
            args[:snaplen], args[:network])
    end
    
    # Called by initialize to set the initial fields. 
    def init_fields(args={})
      args[:magic] = @int32.new(args[:magic] || PcapHeader::MAGIC_INT32)
      args[:ver_major] = @int16.new(args[:ver_major] || 2)
      args[:ver_minor] ||= @int16.new(args[:ver_minor] || 4)
      args[:thiszone] ||= @int32.new(args[:thiszone])
      args[:sigfigs] ||= @int32.new(args[:sigfigs])
      args[:snaplen] ||= @int32.new(args[:snaplen] || 0xffff)
      args[:network] ||= @int32.new(args[:network] || 1)
      return args
    end

    # Returns the object in string form.
    def to_s
      self.to_a[1,7].map {|x| x.to_s}.join
    end

    # Reads a string to populate the object.
    # TODO: Need to test this by getting a hold of a big endian pcap file.
    # Conversion from big to little shouldn't be that big of a deal.
    def read(str)
      force_binary(str)
      return self if str.nil?
      str.force_encoding(Encoding::BINARY) if str.respond_to? :force_encoding
      if str[0,4] == self[:magic].to_s 
        self[:magic].read str[0,4]
        self[:ver_major].read str[4,2]
        self[:ver_minor].read str[6,2]
        self[:thiszone].read str[8,4]
        self[:sigfigs].read str[12,4]
        self[:snaplen].read str[16,4]
        self[:network].read str[20,4]
      else
        raise "Incorrect magic for libpcap"
      end
      self
    end

  end
end
