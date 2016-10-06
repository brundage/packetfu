require 'spec_helper'

describe StructFu::Int16le, "2 byte little-endian value" do

  before :each do
    @int = described_class.new(11)
  end

  it "should behave pretty much like any other 16 bit int" do
    @int.to_s.should == "\x0b\x00"
  end

  it "should raise when you try to change endianness" do
    expect { @int.endian = :big }.to raise_error(NoMethodError, /undefined method `endian='/)
    expect { @int.endian = :little }.to raise_error(NoMethodError, /undefined method `endian='/)
  end

end
