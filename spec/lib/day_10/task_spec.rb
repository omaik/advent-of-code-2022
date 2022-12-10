describe Day10::Task do
  subject(:task) { described_class.new(sample) }

  describe '#call1' do
    context 'when sample input' do
      let(:sample) { true }

      it 'works' do
        expect(task.call1).to eq(13_140)
      end
    end

    context 'when real input' do
      let(:sample) { false }

      it 'works' do
        expect(task.call1).to eq(17_940)
      end
    end
  end

  describe '#call2' do
    context 'when sample input' do
      let(:result) do
        <<~RESULT
          ##..##..##..##..##..##..##..##..##..##..
          ###...###...###...###...###...###...###.
          ####....####....####....####....####....
          #####.....#####.....#####.....#####.....
          ######......######......######......####
          #######.......#######.......#######.....
        RESULT
      end
      let(:sample) { true }

      it 'works' do
        expect(task.call2).to eq(result.strip)
      end
    end

    context 'when real input' do
      let(:result) do
        <<~RESULT
          ####..##..###...##....##.####...##.####.
          ...#.#..#.#..#.#..#....#.#.......#....#.
          ..#..#....###..#..#....#.###.....#...#..
          .#...#....#..#.####....#.#.......#..#...
          #....#..#.#..#.#..#.#..#.#....#..#.#....
          ####..##..###..#..#..##..#.....##..####.
        RESULT
      end
      let(:sample) { false }

      it 'works' do
        expect(task.call2).to eq(result.strip)
      end
    end
  end
end
