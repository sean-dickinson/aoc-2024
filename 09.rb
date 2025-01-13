require "forwardable"
module Day09
  Block = Data.define(:file_id) do
    def empty?
      file_id.nil?
    end

    def used?
      !empty?
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
    extend Forwardable
    def_delegators :@map, :blocks

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
  end

  class DiskMapDefragmenter
    extend Forwardable
    def_delegators :@map, :blocks

    def initialize(map)
      @map = map
      @file_id = blocks.last.file_id
      @file_segment = next_file_segment(blocks.size - 1)
    end

    def defragment!
      until done?
        empty_segment = empty_segment_for(@file_segment)
        unless empty_segment.nil?
          move_blocks!(empty_segment)
        end

        next_file!
      end
    end

    private

    def move_blocks!(empty_segment)
      empty_segment.zip(@file_segment).each do |empty_index, file_index|
        swap_blocks!(empty_index, file_index)
      end
    end

    def swap_blocks!(index1, index2)
      blocks[index1], blocks[index2] = blocks[index2], blocks[index1]
    end

    def next_file!
      @file_id -= 1
      @file_segment = next_file_segment(@file_segment.min - 1)
    end

    def done? = @file_segment.nil?

    def empty_segment_for(file_segment)
      # There's probably something more clever to do here so you don't start from the beginning each time?
      candidate = next_empty_segment(0)

      until is_valid_segment(candidate, file_segment)
        break if candidate.nil?
        candidate = next_empty_segment(candidate.last + 1)
      end

      candidate&.take(file_segment.size)
    end

    def is_valid_segment(candidate, file_segment)
      return false if candidate.nil?

      [
        candidate.size >= file_segment.size,
        candidate.first < file_segment.first,
        candidate.last < file_segment.last
      ].all?
    end

    def next_empty_segment(starting_index)
      start = next_empty_block(starting_index)
      return nil if start.nil?
      finish = last_empty_block(start)
      return nil if finish.nil?

      (start..finish)
    end

    def next_file_segment(starting_index)
      start = first_file_block(@file_id, starting_index)
      finish = last_file_block(@file_id, start)
      return nil if start.nil? || finish.nil?

      # these are reversed since we're searching from the back
      (finish..start)
    end

    def next_empty_block(starting_index = 0)
      relative_index = blocks.drop(starting_index).index { |block| block.empty? }
      return nil if relative_index.nil?

      starting_index + relative_index
    end

    def last_empty_block(starting_index = 0)
      relative_index = blocks.drop(starting_index).index { |block| block.used? }
      return nil if relative_index.nil?

      starting_index + relative_index - 1
    end

    def last_file_block(file_id, starting_index)
      first_non_matching_block = blocks.take(starting_index).rindex { |block| block.file_id != file_id }
      return nil if first_non_matching_block.nil?

      first_non_matching_block + 1
    end

    def first_file_block(file_id, starting_index)
      blocks.take(starting_index + 1).rindex { |block| block.file_id == file_id }
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
      factory = DiskMapFactory.new(input.first)
      map = factory.parse
      defragmenter = DiskMapDefragmenter.new(map)

      defragmenter.defragment!

      map.checksum
    end
  end
end
