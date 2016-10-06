describe PacketFu::Capture do

  let(:capture) { described_class.new start: start }
  let(:filter) { 'ip' }
  let(:start) { false }

  it 'raises an exception when trying to capture without root' do
    expect { capture.capture }.to raise_error(RuntimeError)
  end


#  it 'sets a filter' do
#    expect(capture.filter).to be_nil
#    capture.bpf filter: filter
#    expect(capture.filter).not_to be_nil
#  end

end
