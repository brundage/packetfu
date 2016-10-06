describe PacketFu::Config do

  let(:config) { described_class.new }
  let(:config_hash) { { pcapfile: default_pcap_file } }
  let(:default_pcap_file) { '/tmp/out.pcap' }


  it 'initializes pcapfile' do
    expect(config.pcapfile).to eq default_pcap_file
  end


  it 'returns a hash of its config' do
    expect(config.config).to eq config_hash
  end

end
