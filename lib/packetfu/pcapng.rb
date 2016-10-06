# -*- coding: binary -*-

module PacketFu

  # Module to handle PCAP-NG file format.
  # See http://xml2rfc.tools.ietf.org/cgi-bin/xml2rfc.cgi?url=https://raw.githubusercontent.com/pcapng/pcapng/master/draft-tuexen-opsawg-pcapng.xml&modeAsFormat=html/ascii&type=ascii#format_idb
  module PcapNG

    autoload :Block, 'packetfu/pcapng/block'
    autoload :File, 'packetfu/pcapng/file'
    autoload :EPB, 'packetfu/pcapng/epb'
    autoload :IDB, 'packetfu/pcapng/idb'
    autoload :SHB, 'packetfu/pcapng/shb'
    autoload :SPB, 'packetfu/pcapng/spb'
    autoload :UnknownBlock, 'packetfu/pcapng/unknown_block'

    # Section Header Block type number
    SHB_TYPE = StructFu::Int32.new(0x0A0D0D0A, :little)
    # Interface Description Block type number
    IDB_TYPE = StructFu::Int32.new(1, :little)
    # Simple Packet Block type number
    SPB_TYPE = StructFu::Int32.new(3, :little)
    # Enhanced Packet Block type number
    EPB_TYPE = StructFu::Int32.new(6, :little)

    # Various LINKTYPE values from http://www.tcpdump.org/linktypes.html
    # FIXME: only ETHERNET type is defined as this is the only link layer
    # type supported by PacketFu
    LINKTYPE_ETHERNET = 1

    class Error < StandardError; end
    class InvalidFileError < Error; end

  end

end


