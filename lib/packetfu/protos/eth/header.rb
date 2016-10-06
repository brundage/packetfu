# -*- coding: binary -*-
module PacketFu
  # EthHeader is a complete Ethernet struct, used in EthPacket. 
  # It's the base header for all other protocols, such as IPHeader, 
  # TCPHeader, etc. 
  #
  # For more on the construction on MAC addresses, see 
  # http://en.wikipedia.org/wiki/MAC_address
  #
  # TODO: Need to come up with a good way of dealing with vlan
  # tagging. Having a usually empty struct member seems weird,
  # but there may not be another way to do it if I want to preserve
  # the Eth-ness of vlan-tagged 802.1Q packets. Also, may as well
  # deal with 0x88a8 as well (http://en.wikipedia.org/wiki/802.1ad)
  #
  # ==== Header Definition
  #
  #  EthMac  :eth_dst                     # See EthMac
  #  EthMac  :eth_src                     # See EthMac
  #  Int16   :eth_proto, Default: 0x8000  # IP 0x0800, Arp 0x0806
  #  String  :body
  class EthHeader < Struct.new(:eth_dst, :eth_src, :eth_proto, :body)
    include ::StructFu

    def initialize(args={})
      super(
        EthMac.new.read(args[:eth_dst]),
        EthMac.new.read(args[:eth_src]),
        Int16.new(args[:eth_proto] || 0x0800),
        StructFu::String.new.read(args[:body])
      )
    end

    # Setter for the Ethernet destination address.
    def eth_dst=(i); typecast(i); end
    # Getter for the Ethernet destination address.
    def eth_dst; self[:eth_dst].to_s; end
    # Setter for the Ethernet source address.
    def eth_src=(i); typecast(i); end
    # Getter for the Ethernet source address.
    def eth_src; self[:eth_src].to_s; end
    # Setter for the Ethernet protocol number.
    def eth_proto=(i); typecast(i); end
    # Getter for the Ethernet protocol number.
    def eth_proto; self[:eth_proto].to_i; end

    # Returns the object in string form.
    def to_s
      self.to_a.map {|x| x.to_s}.join
    end

    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      self[:eth_dst].read str[0,6]
      self[:eth_src].read str[6,6]
      self[:eth_proto].read str[12,2]
      self[:body].read str[14,str.size]
      self
    end

    # Converts a readable MAC (11:22:33:44:55:66) to a binary string. 
    # Readable MAC's may be split on colons, dots, spaces, or underscores.
    #
    # irb> PacketFu::EthHeader.mac2str("11:22:33:44:55:66")
    #
    # #=> "\021\"3DUf"
    def self.mac2str(mac)
      if mac.split(/[:\x2d\x2e\x5f]+/).size == 6
        ret =	mac.split(/[:\x2d\x2e\x20\x5f]+/).collect {|x| x.to_i(16)}.pack("C6")
      else
        raise ArgumentError, "Unkown format for mac address."
      end
      return ret
    end

    # Converts a binary string to a readable MAC (11:22:33:44:55:66). 
    #
    # irb> PacketFu::EthHeader.str2mac("\x11\x22\x33\x44\x55\x66")
    #
    # #=> "11:22:33:44:55:66"
    def self.str2mac(mac='')
      if mac.to_s.size == 6 && mac.kind_of?(::String)
        ret = mac.unpack("C6").map {|x| sprintf("%02x",x)}.join(":")
      end
    end

    # Sets the source MAC address in a more readable way.
    def eth_saddr=(mac)
      mac = EthHeader.mac2str(mac)
      self[:eth_src].read mac
      self[:eth_src]
    end

    # Gets the source MAC address in a more readable way. 
    def eth_saddr
      EthHeader.str2mac(self[:eth_src].to_s)
    end

    # Set the destination MAC address in a more readable way.
    def eth_daddr=(mac)
      mac = EthHeader.mac2str(mac)
      self[:eth_dst].read mac
      self[:eth_dst]
    end

    # Gets the destination MAC address in a more readable way. 
    def eth_daddr
      EthHeader.str2mac(self[:eth_dst].to_s)
    end

    # Readability aliases

    alias :eth_dst_readable :eth_daddr
    alias :eth_src_readable :eth_saddr

    def eth_proto_readable
      "0x%04x" % eth_proto
    end

  end
end
