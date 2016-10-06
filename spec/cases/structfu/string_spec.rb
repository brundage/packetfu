require 'spec_helper'

describe StructFu::String, "a sligtly more special String" do

  before :each do
    @str = described_class.new("Oi, a string")
  end

  it "should behave pretty much like a string" do
    @str.should be_kind_of(String)
  end

  it "should have a read method" do
    @str.should respond_to(:read)
  end

  it "should read data like other StructFu things" do
    @str.read("hello")
    @str.should == "hello"
  end

end
