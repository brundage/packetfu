require 'spec_helper'

class StructClass
  include StructFu
end

describe StructFu, "mixin methods" do

  let(:sc) { StructClass.new }

  it "should provide StructFu#sz" do
    sc.should respond_to :sz
  end
  
  it "should provide StructFu#len" do
    sc.should respond_to :len
  end

  it "should provide StructFu#typecast" do
    sc.should respond_to :typecast
  end

  it "should provide StructFu#body=" do
    sc.should respond_to :body=
  end
end
