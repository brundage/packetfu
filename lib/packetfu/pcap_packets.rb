# -*- coding: binary -*-
module PacketFu
  # PcapPackets is a collection of PcapPacket objects.
  class PcapPackets < Array

    include StructFu

    attr_accessor :endian # probably ought to be read-only but who am i.

    def initialize(args={})
      @endian = args[:endian] || :little
    end

    def force_binary(str)
      str.force_encoding Encoding::BINARY if str.respond_to? :force_encoding
    end

    # Reads a string to populate the object. Note, this read takes in the 
    # whole pcap file, since we need to see the magic to know what 
    # endianness we're dealing with.
    def read(str)
      force_binary(str)
      return self if str.nil?
      if str[0,4] == PcapHeader::MAGIC_BIG
        @endian = :big
      elsif str[0,4] == PcapHeader::MAGIC_LITTLE
        @endian = :little
      else
        raise ArgumentError, "Unknown file format for #{self.class}"
      end
      body = str[24,str.size]
      while body.size > 16 # TODO: catch exceptions on malformed packets at end
        p = PcapPacket.new(:endian => @endian)
        p.read(body)
        self<<p
        body = body[p.sz,body.size]
      end
    self
    end

    def to_s
      self.join
    end

  end
end
