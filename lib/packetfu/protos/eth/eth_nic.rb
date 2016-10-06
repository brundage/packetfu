# -*- coding: binary -*-
module PacketFu
  # EthNic is the Network Interface Controler portion of a MAC address, used in EthHeader.
  #
  # ==== Header Definition
  #
  #  Fixnum :n1
  #  Fixnum :n2
  #  Fixnum :n3
  #
  class EthNic < Struct.new(:n0, :n1, :n2)

    # EthNic does not enjoy StructFu typing.
    def initialize(args={})
      args.each_pair {|k,v| args[k] = 0 unless v} 
      super(args[:n0], args[:n1], args[:n2])
    end

    # Returns the object in string form.
    def to_s
      [n0,n1,n2].map {|x| x.to_i}.pack("C3")
    end
    
    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      self[:n0], self[:n1], self[:n2] = str[0,3].unpack("C3")
      self
    end

  end
end
