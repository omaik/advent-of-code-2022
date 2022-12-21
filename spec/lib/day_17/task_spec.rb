describe Day17::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(3068)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(3166)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(1_514_285_714_288)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call2).to eq(1_577_207_977_186)
      end
    end
  end
end
