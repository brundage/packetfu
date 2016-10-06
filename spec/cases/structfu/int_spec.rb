require 'spec_helper'

describe StructFu::Int, "basic Int class" do

  before :each do
    @int = described_class.new(8)
  end

  it "should have an initial state" do
    new_int = described_class.new
    new_int.value.should be_nil
    new_int.endian.should be_nil
    new_int.width.should be_nil
    new_int.default.should == 0
  end

  it "should raise when to_s'ed directly" do
    expect { @int.to_s}.to raise_error(StandardError, "#{described_class.name}#to_s accessed, must be redefined.")
  end

  it "should have a value of 8" do
    @int.value.should == 8
    @int.to_i.should == 8
    @int.to_f.to_s.should == "8.0"
  end

  it "should read an integer" do
    @int.read(7)
    @int.to_i.should == 7
  end

end
