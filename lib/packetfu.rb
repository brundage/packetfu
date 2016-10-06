# -*- coding: binary -*-
require 'packetfu/version'

autoload :StructFu, 'structfu'

module PacketFu

  autoload :Capture, 'packetfu/capture'
  autoload :Config, 'packetfu/config'
  autoload :Inject, 'packetfu/inject'
  autoload :Packet, 'packetfu/packet'
  autoload :PcapFile, 'packetfu/pcap_file'
  autoload :PcapHeader, 'packetfu/pcap_header'
  autoload :PcapNG, 'packetfu/pcapng'
  autoload :PcapPacket, 'packetfu/pcap_packet'
  autoload :PcapPackets, 'packetfu/pcap_packets'
  autoload :Read, 'packetfu/deprecated/read'
  autoload :Timestamp, 'packetfu/timestamp'
  autoload :Utils, 'packetfu/utils'
  autoload :Write, 'packetfu/deprecated/write'

  # Deal with Ruby's encoding by ignoring it.
  def self.force_binary(str)
    str.force_encoding Encoding::BINARY if str.respond_to? :force_encoding
  end

  # Sets the expected byte order for a pcap file. See PacketFu::Read.set_byte_order
  @byte_order = :little


  # Returns an array of classes defined in PacketFu
  def self.classes
    constants.map { |const| const_get(const) if const_get(const).kind_of? Class}.compact
  end


  # Adds the class to PacketFu's list of packet classes -- used in packet parsing.
  def self.add_packet_class(klass)
    raise "Need a class" unless klass.kind_of? Class
    if klass.name !~ /[A-Za-z0-9]Packet/
      raise "Packet classes should be named 'ProtoPacket'"
    end
    @packet_classes ||= []
    @packet_classes << klass
    self.clear_packet_groups
    @packet_classes.sort_by! { |x| x.name }
  end

  # Presumably, there may be a time where you'd like to remove a packet class.
  def self.remove_packet_class(klass)
    raise "Need a class" unless klass.kind_of? Class
    @packet_classes ||= []
    @packet_classes.delete klass
    self.clear_packet_groups
    @packet_classes
  end

  # Returns an array of packet classes
  def self.packet_classes
    @packet_classes || []
  end

  # Returns an array of packet types by packet prefix.
  def self.packet_prefixes
    return [] if @packet_classes.nil?
    self.reset_packet_groups unless @packet_class_prefixes
    @packet_class_prefixes
  end

  def self.packet_classes_by_layer
    return [] if @packet_classes.nil?
    self.reset_packet_groups unless @packet_classes_by_layer
    @packet_classes_by_layer
  end

  def self.packet_classes_by_layer_without_application
    return [] if @packet_classes.nil?
    self.reset_packet_groups unless @packet_classes_by_layer_without_application
    @packet_classes_by_layer_without_application
  end

  def self.clear_packet_groups
    @packet_class_prefixes = nil
    @packet_classes_by_layer = nil
    @packet_classes_by_layer_without_application = nil
  end

  def self.reset_packet_groups
 		@packet_class_prefixes = @packet_classes.map {|p| p.to_s.split("::").last.to_s.downcase.gsub(/packet$/,"")}
    @packet_classes_by_layer = @packet_classes.sort_by { |pclass| pclass.layer }.reverse
    @packet_classes_by_layer_without_application = @packet_classes_by_layer.reject { |pclass| pclass.layer_symbol == :application }
  end

  # The current inspect style. One of :hex, :dissect, or :default
  # Note that :default means Ruby's default, which is usually
  # far too long to be useful.
  def self.inspect_style
    @inspect_style ||= :dissect
  end

  # Setter for PacketFu's @inspect_style
  def self.inspect_style=(arg)
    @inspect_style = case arg
      when :hex, :pretty
        :hex
      when :dissect, :verbose
        :dissect
      when :default, :ugly
        :default
      else
        :dissect
      end
  end

  # Switches inspect styles in a round-robin fashion between
  # :dissect, :default, and :hex
  def toggle_inspect
    case @inspect_style
    when :hex, :pretty
      @inspect_style = :dissect
    when :dissect, :verbose
      @inspect_style = :default
    when :default, :ugly
      @inspect_style = :hex
    else
      @inspect_style = :dissect
    end
  end
end
require 'packetfu/protos'
