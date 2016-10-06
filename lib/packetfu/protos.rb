# Picks up all the protocols defined in the protos subdirectory
module PacketFu
  autoload :ARPPacket,      'packetfu/protos/arp'
  autoload :ARPHeader,      'packetfu/protos/arp/header'
  autoload :ARPHeaderMixin, 'packetfu/protos/arp/mixin'

  autoload :EthPacket,      'packetfu/protos/eth'
  autoload :EthHeader,      'packetfu/protos/eth/header'
  autoload :EthHeaderMixin, 'packetfu/protos/eth/mixin'
  autoload :EthMac,         'packetfu/protos/eth/eth_mac'
  autoload :EthNic,         'packetfu/protos/eth/eth_nic'
  autoload :EthOui,         'packetfu/protos/eth/eth_oui'

  autoload :HSRPPacket,      'packetfu/protos/hsrp'
  autoload :HSRPHeader,      'packetfu/protos/hsrp/header'
  autoload :HSRPHeaderMixin, 'packetfu/protos/hsrp/mixin'

  autoload :ICMPPacket,      'packetfu/protos/icmp'
  autoload :ICMPHeader,      'packetfu/protos/icmp/header'
  autoload :ICMPHeaderMixin, 'packetfu/protos/icmp/mixin'

  autoload :ICMPv6Packet,      'packetfu/protos/icmpv6'
  autoload :ICMPv6Header,      'packetfu/protos/icmpv6/header'
  autoload :ICMPv6HeaderMixin, 'packetfu/protos/icmpv6/mixin'

  autoload :IPPacket,      'packetfu/protos/ip'
  autoload :IPHeader,      'packetfu/protos/ip/header'
  autoload :IPHeaderMixin, 'packetfu/protos/ip/mixin'

  autoload :IPv6Packet,      'packetfu/protos/ipv6'
  autoload :IPv6Header,      'packetfu/protos/ipv6/header'
  autoload :IPv6HeaderMixin, 'packetfu/protos/ipv6/mixin'

  autoload :LLDPPacket,      'packetfu/protos/lldp'
  autoload :LLDPHeader,      'packetfu/protos/lldp/header'
  autoload :LLDPHeaderMixin, 'packetfu/protos/lldp/mixin'

  autoload :InvalidPacket,   'packetfu/protos/invalid'

  autoload :TCPPacket,      'packetfu/protos/tcp'
  autoload :TcpEcn,         'packetfu/protos/tcp/ecn'
  autoload :TcpFlags,       'packetfu/protos/tcp/flags'
  autoload :TCPHeader,      'packetfu/protos/tcp/header'
  autoload :TcpHlen,        'packetfu/protos/tcp/hlen'
  autoload :TCPHeaderMixin, 'packetfu/protos/tcp/mixin'
  autoload :TcpOption,      'packetfu/protos/tcp/option'
  autoload :TcpOptions,     'packetfu/protos/tcp/options'
  autoload :TcpReserved,    'packetfu/protos/tcp/reserved'

  autoload :UDPPacket,      'packetfu/protos/udp'
  autoload :UDPHeader,      'packetfu/protos/udp/header'
  autoload :UDPHeaderMixin, 'packetfu/protos/udp/mixin'

end
