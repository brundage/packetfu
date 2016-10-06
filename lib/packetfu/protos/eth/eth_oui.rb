# -*- coding: binary -*-
module PacketFu
  # EthOui is the Organizationally Unique Identifier portion of a MAC address, used in EthHeader.
  #
  # See the OUI list at http://standards.ieee.org/regauth/oui/oui.txt
  #
  # ==== Header Definition
  #
  #  Fixnum   :b0
  #  Fixnum   :b1
  #  Fixnum   :b2
  #  Fixnum   :b3
  #  Fixnum   :b4
  #  Fixnum   :b5
  #  Fixnum   :local
  #  Fixnum   :multicast
  #  Int16    :oui,       Default: 0x1ac5 :)
  class EthOui < Struct.new(:b5, :b4, :b3, :b2, :b1, :b0, :local, :multicast, :oui)

    # EthOui is unusual in that the bit values do not enjoy StructFu typing.
    def initialize(args={})
      args[:local] ||= 0 
      args[:oui] ||= 0x1ac # :)
      args.each_pair {|k,v| args[k] = 0 unless v} 
      super(args[:b5], args[:b4], args[:b3], args[:b2], 
            args[:b1], args[:b0], args[:local], args[:multicast], 
            args[:oui])
    end

    # Returns the object in string form.
    def to_s
      byte = 0
      byte += 0b10000000 if b5.to_i == 1
      byte += 0b01000000 if b4.to_i == 1
      byte += 0b00100000 if b3.to_i == 1
      byte += 0b00010000 if b2.to_i == 1
      byte += 0b00001000 if b1.to_i == 1
      byte += 0b00000100 if b0.to_i == 1
      byte += 0b00000010 if local.to_i == 1
      byte += 0b00000001 if multicast.to_i == 1
      [byte,oui].pack("Cn")
    end

    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      if 1.respond_to? :ord
        byte = str[0].ord
      else
        byte = str[0]
      end
      self[:b5] =        byte & 0b10000000 == 0b10000000 ? 1 : 0
      self[:b4] =        byte & 0b01000000 == 0b01000000 ? 1 : 0
      self[:b3] =        byte & 0b00100000 == 0b00100000 ? 1 : 0
      self[:b2] =        byte & 0b00010000 == 0b00010000 ? 1 : 0
      self[:b1] =        byte & 0b00001000 == 0b00001000 ? 1 : 0
      self[:b0] =        byte & 0b00000100 == 0b00000100 ? 1 : 0
      self[:local] =     byte & 0b00000010 == 0b00000010 ? 1 : 0
      self[:multicast] = byte & 0b00000001 == 0b00000001 ? 1 : 0
      self[:oui] =       str[1,2].unpack("n").first
      self
    end

  end
end
