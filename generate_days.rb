class GenerateDay
  CLASS_CODE = <<~EOF
    module Day%<day>s
      class Task
        def initialize(sample)
          @sample = sample
        end

        def call1
        end

        def call2
        end

        def input
          @input ||= Input.call(@sample)
        end
      end
    end
  EOF

  INPUT_CODE = <<~EOF
    module Day%<day>s
      class Input
        class << self
          INPUT_FILE_PATH = "\#{__dir__}/input.txt".freeze
          SAMPLE_INPUT_FILE_PATH = "\#{__dir__}/input.sample.txt".freeze

          def call(sample)
            data(sample).split("\\n")
          end

          def data(sample)
            sample ? File.read(SAMPLE_INPUT_FILE_PATH) : File.read(INPUT_FILE_PATH)
          end
        end
      end
    end
  EOF

  SPEC_CODE = <<~EOF
    describe Day%<day>s::Task do
      subject(:task) { described_class.new(sample) }

      describe '#call1' do
        context 'when sample input' do
          let(:sample) { true }

          it 'works' do
            expect(task.call1).to eq(nil)
          end
        end

        context 'when real input' do
          let(:sample) { false }

          it 'works' do
            expect(task.call1).to eq(nil)
          end
        end
      end

      describe '#call2' do
        context 'when sample input' do
          let(:sample) { true }

          it 'works' do
            expect(task.call2).to eq(nil)
          end
        end

        context 'when real input' do
          let(:sample) { false }

          it 'works' do
            expect(task.call2).to eq(nil)
          end
        end
      end
    end
  EOF

  def initialize(day)
    @day = day
  end

  def call
    create_directory
    create_spec_direcroty
    create_input_files
    create_class_file
    create_spec_file
  end

  def create_directory
    Dir.mkdir("lib/day_#{@day}")
  end

  def create_spec_direcroty
    Dir.mkdir("spec/lib/day_#{@day}")
  end

  def create_input_files
    File.write("lib/day_#{@day}/input.txt", '')
    File.write("lib/day_#{@day}/input.sample.txt", '')
    File.write("lib/day_#{@day}/input.rb", format(INPUT_CODE, day: @day))
  end

  def create_class_file
    File.write("lib/day_#{@day}/task.rb", format(CLASS_CODE, day: @day))
  end

  def create_spec_file
    File.write("spec/lib/day_#{@day}/task_spec.rb", format(SPEC_CODE, day: @day))
  end
end

(1..25).each do |day|
  GenerateDay.new(day).call
end
