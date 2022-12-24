describe Day20::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(3)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(3346)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(1_623_178_306)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      # too slow :(
      xit 'works' do
        expect(task.call2).to eq(4_265_712_588_168)
      end
    end
  end
end
