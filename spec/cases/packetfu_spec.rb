require 'spec_helper'

describe PacketFu, "instance variables" do
  it "should have a a byte_order" do
    described_class.instance_variable_get(:@byte_order).should == :little
  end
end

describe PacketFu, "protocol requires" do
  it "should have some protocols defined" do
    PacketFu::EthPacket.should_not be_nil
    PacketFu::IPPacket.should_not be_nil
    PacketFu::TCPPacket.should_not be_nil
    expect { PacketFu::FakePacket }.to raise_error(NameError, /uninitialized constant PacketFu::FakePacket/)
  end
end

describe PacketFu, "packet class list management" do

  it "should allow packet class registration" do
    described_class.add_packet_class(PacketFu::FooPacket).should be_kind_of Array
    described_class.add_packet_class(PacketFu::BarPacket).should be_kind_of Array
  end

  its(:packet_classes) {should include(PacketFu::FooPacket)}

  it "should disallow non-classes as packet classes" do
    expect { described_class.add_packet_class("A String") }.to raise_error(RuntimeError, "Need a class")
  end

  its(:packet_prefixes) {should include("bar")}

  # Don't really have much utility for this right now.
  it "should allow packet class deregistration" do
    described_class.remove_packet_class(PacketFu::BarPacket)
    described_class.packet_prefixes.should_not include("bar")
    described_class.add_packet_class(PacketFu::BarPacket)
  end

end
