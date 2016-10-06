# -*- coding: binary -*-
module PacketFu
  class EthMac < Struct.new(:oui, :nic)

    def initialize(args={})
      super(
      EthOui.new.read(args[:oui]),
      EthNic.new.read(args[:nic]))
    end

    # Returns the object in string form.
    def to_s
      "#{self[:oui]}#{self[:nic]}"
    end

    # Reads a string to populate the object.
    def read(str)
      force_binary(str)
      return self if str.nil?
      self.oui.read str[0,3]
      self.nic.read str[3,3]
      self
    end

  end
end
