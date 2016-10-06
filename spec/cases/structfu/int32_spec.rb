require 'spec_helper'

describe StructFu::Int32, "four byte value" do

  before :each do
    @int = described_class.new(11)
  end

  it "should have an initial state" do
    new_int = described_class.new
    new_int.value.should be_nil
    new_int.endian.should == :big
    new_int.width.should == 4
    new_int.default.should == 0
  end

  it "should print a four character packed string" do
    @int.to_s.should == "\x00\x00\x00\x0b"
  end

  it "should have a value of 11" do
    @int.value.should == 11
    @int.to_i.should == 11
    @int.to_f.to_s.should == "11.0"
  end

  it "should reset with a new integer" do
    @int.read(2)
    @int.to_i.should == 2
    @int.to_s.should == "\x00\x00\x00\x02"
    @int.read(254)
    @int.to_i.should == 254
    @int.to_s.should == "\x00\x00\x00\xfe".force_encoding("binary")
  end

  it "should be able to set endianness" do
    int_be = described_class.new(11,:big)
    int_be.to_s.should == "\x00\x00\x00\x0b"
    int_le = described_class.new(11,:little)
    int_le.to_s.should == "\x0b\x00\x00\x00"
  end

  it "should be able to switch endianness" do
    @int.endian.should == :big
    @int.to_s.should == "\x00\x00\x00\x0b"
    @int.endian = :little
    @int.endian.should == :little
    @int.read(11)
    @int.to_s.should == "\x0b\x00\x00\x00"
  end

end
