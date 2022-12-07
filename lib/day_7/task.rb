module Day7
  class Task
    def initialize(sample)
      @sample = sample
    end

    def call1
      context = Context.new

      root = Directory.new('/')
      context.current_directory = root

      input.each do |command|
        command.execute(context)
      end
      context.directories.select { |x| x.size <= 100_000 }.map(&:size).sum
    end

    def call2
      context = Context.new

      root = Directory.new('/')
      context.current_directory = root

      input.each do |command|
        command.execute(context)
      end

      overflow = root.size - 40_000_000

      context.directories.select { |x| x.size > overflow }.min_by(&:size).size
    end

    def input
      @input ||= Input.call(@sample)
    end
  end

  class Command
    def initialize(x)
      @input = x
    end

    def execute(context)
      if @input.start_with?('ls')
        execute_ls(context)
      else
        execute_cd(context)
      end
    end

    def execute_cd(context)
      context.cd(@input.gsub('cd ', ''))
    end

    def execute_ls(context)
      @input.split("\n")[1..].map(&:strip).each do |x|
        if x.start_with?('dir')
          dir = Directory.new(x.gsub('dir ', ''))
          context.add_directory(dir)
        else
          file_size = x.match(/\d+/)[0].to_i
          context.add_file(File.new(file_size))
        end
      end
    end
  end

  Directory = Struct.new(:name, :parent, :children) do
    def initialize(name, parent = nil, children = [])
      super
    end

    def size
      children.map(&:size).sum
    end
  end

  File = Struct.new(:size, :name)

  class Context
    attr_writer :current_directory
    attr_reader :directories

    def initialize
      @current_directory = nil
      @directories = []
    end

    def add_directory(directory)
      @current_directory.children << directory
      directory.parent = @current_directory
      @directories << directory
    end

    def add_file(file)
      @current_directory.children << file
    end

    def cd(name)
      @current_directory = if name == '..'
                             @current_directory.parent
                           else
                             @current_directory.children.find { |x| x.name == name }
                           end
    end
  end
end
