module Day09
  Block = Data.define(:file_id) do
    def empty?
      file_id.nil?
    end

    def to_s
      if empty?
        "."
      else
        file_id.to_s
      end
    end
  end

  class DiskMapFactory
    def initialize(input)
      @input = input
      @file_id = 0
      @blocks = []
    end

    def parse
      process_input!
      DiskMap.new(@blocks)
    end

    private

    def process_input!
      @input.chars.map(&:to_i).each_with_index do |number, index|
        if index.even?
          create_file_blocks(@file_id, number)
          @file_id += 1
        else
          create_empty_blocks(number)
        end
      end
    end

    def create_empty_blocks(num_blocks)
      num_blocks.times do
        @blocks << Block.new(nil)
      end
    end

    def create_file_blocks(file_id, num_blocks)
      num_blocks.times do
        @blocks << Block.new(file_id)
      end
    end
  end

  class DiskMap
    attr_reader :blocks
    def initialize(blocks)
      @blocks = blocks
    end

    def checksum
      blocks.each_with_index.sum do |block, index|
        index * (block.file_id || 0)
      end
    end

    def to_s
      blocks.map(&:to_s).join
    end
  end

  class DiskMapCompactor
    def initialize(map)
      @map = map
      @left_pointer = leftmost_empty_position(0)
      @right_pointer = rightmost_file_block(blocks.size)
    end

    def compact!
      until invalid_pointers?
        move_blocks!
        reset_pointers!
      end
    end

    private

    def blocks
      @map.blocks
    end

    def invalid_pointers?
      [
        @left_pointer.nil?,
        @right_pointer.nil?,
        @left_pointer > @right_pointer
      ].any?
    end

    def move_blocks!
      blocks[@left_pointer], blocks[@right_pointer] = blocks[@right_pointer], blocks[@left_pointer]
    end

    def reset_pointers!
      @left_pointer = leftmost_empty_position(@left_pointer + 1)
      @right_pointer = rightmost_file_block(@right_pointer)
    end

    def leftmost_empty_position(starting_index)
      relative_index = blocks.drop(starting_index).index { |block| block.empty? }
      return nil if relative_index.nil?

      starting_index + relative_index
    end

    def rightmost_file_block(starting_index)
      blocks.take(starting_index).rindex { |block| !block.empty? }
    end

    def reverse_index(index)
      blocks.size - index - 1
    end
  end

  class << self
    def part_one(input)
      factory = DiskMapFactory.new(input.first)
      map = factory.parse
      compactor = DiskMapCompactor.new(map)

      compactor.compact!

      map.checksum
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
