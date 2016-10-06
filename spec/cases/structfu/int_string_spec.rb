require 'spec_helper'

describe StructFu::IntString do

  it "should be" do
    described_class.should be
  end

  it "should have a length and value" do
    istr = described_class.new("Avast!")
    istr.to_s.should == "\x06Avast!"
  end

  it "should have a 16-bit length and a value" do
    istr = described_class.new("Avast!",StructFu::Int16)
    istr.to_s.should == "\x00\x06Avast!"
  end

  it "should have a 32-bit length and a value" do
    istr = described_class.new("Avast!",StructFu::Int32)
    istr.to_s.should == "\x00\x00\x00\x06Avast!"
  end

  before :each do
    @istr = described_class.new("Avast!",StructFu::Int32)
  end

  it "should report the correct length with a new string" do
    @istr.to_s.should == "\x00\x00\x00\x06Avast!"
    @istr.string = "Ahoy!"
    @istr.to_s.should == "\x00\x00\x00\x05Ahoy!"
  end

  it "should report the correct length with a new string" do
    @istr.string = "Ahoy!"
    @istr.to_s.should == "\x00\x00\x00\x05Ahoy!"
  end

  it "should keep the old length with a new string" do
    @istr[:string] = "Ahoy!"
    @istr.to_s.should == "\x00\x00\x00\x06Ahoy!"
  end

  it "should allow for adjusting the length manually" do
    @istr.len = 16
    @istr.to_s.should == "\x00\x00\x00\x10Avast!"
  end

  it "should read in an expected string" do
    data = "\x00\x00\x00\x09Yo ho ho!"
    @istr.read(data)
    @istr.to_s.should == data
  end

  it "should raise when a string is too short" do
    data = "\x01A"
    expect { @istr.read(data) }.to raise_error(StandardError, "String is too short for type StructFu::Int32")
  end

end
