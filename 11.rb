require "forwardable"
module Day11
  StoneCollection = Data.define(:stones) do
    extend Forwardable

    def_delegators :stones, :size

    def +(other)
      with(stones: stones + other.stones)
    end

    def blink
      return blink_one if one?

      stones.each_slice(size / 2).map do |some_stones|
        with(stones: some_stones).blink
      end.inject(:+)
    end

    private

    def from(s)
      with(stones: s)
    end

    def blink_one
      return with(stones: [1]) if number.zero?

      if digit_count.even?
        with(stones: split_number)
      else
        with(stones: [number * 2024])
      end
    end

    def number
      stones.first
    end

    def one?
      size == 1
    end

    def digit_count
      number.to_s.size
    end

    def split_number
      number.to_s.chars.each_slice(digit_count / 2).map(&:join).map(&:to_i)
    end
  end

  class StoneFactory
    def initialize(input)
      @input = input
    end

    def create!
      StoneCollection.new(@input.split.map(&:to_i))
    end
  end

  class << self
    def part_one(input)
      stones = StoneFactory.new(input.first).create!
      25.times do
        stones = stones.blink
      end
      stones.size
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
