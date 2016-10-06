describe PacketFu, "version information" do
  it "reports a version number" do
    PacketFu::VERSION.should match /^1\.[0-9]+\.[0-9]+(.pre)?$/
  end
  its(:version) {should eq PacketFu::VERSION}

  it "can compare version strings" do
    described_class.binarize_version("1.2.3").should == 0x010203
    described_class.binarize_version("3.0").should == 0x030000
    described_class.at_least?("1.0").should be true
    described_class.at_least?("4.0").should be false
    described_class.older_than?("4.0").should be true
    described_class.newer_than?("1.0").should be true
  end

  it "can handle .pre versions" do
    described_class.binarize_version("1.7.6.pre").should == 0x010706
    described_class.at_least?("0.9.0.pre").should be true
  end
end
