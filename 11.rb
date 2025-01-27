require "forwardable"
module Day11
  StoneCollection = Data.define(:stones) do
    class << self
      def from_numbers(numbers)
        new(numbers.map { |number| Stone.new(number: number) })
      end
    end

    extend Forwardable

    def_delegators :stones, :size

    def +(other)
      if other.is_a? Stone
        with(stones: stones + [other])
      elsif other.is_a? StoneCollection
        with(stones: stones + other.stones)
      else
        raise ArgumentError, "Can only add a Stone or a StoneCollection"
      end
    end

    def blink
      stones.map do |stone|
        stone.blink
      end.inject(:+)
    end

    def blink_count(iterations = 1)
      stones.sum do |stone|
        stone.blink_count(iterations)
      end
    end
  end

  Stone = Data.define(:number) do
    @cache = {}

    class << self
      def fetch(stone, iteration, &block)
        @cache[cache_key(stone, iteration)] ||= block.call
      end

      private

      def cache_key(stone, iteration)
        [stone.number, iteration]
      end
    end
    def blink
      return with(number: 1) if number.zero?

      if digit_count.even?
        StoneCollection.from_numbers(split_number)
      else
        with(number: number * 2024)
      end
    end

    def blink_count(iterations = 1)
      self.class.fetch(self, iterations) do
        if iterations == 1
          blink.size
        else
          blink.blink_count(iterations - 1)
        end
      end
    end

    def size = 1

    def +(other)
      if other.is_a? Stone
        StoneCollection.from_numbers([number, other.number])
      elsif other.is_a? StoneCollection
        StoneCollection.from_numbers([number]) + other
      else
        raise ArgumentError, "Can only add a Stone or a StoneCollection"
      end
    end

    private

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
      StoneCollection.from_numbers(@input.split.map(&:to_i))
    end
  end

  class << self
    def part_one(input)
      stones = StoneFactory.new(input.first).create!
      stones.blink_count(25)
    end

    def part_two(input)
      stones = StoneFactory.new(input.first).create!
      stones.blink_count(75)
    end
  end
end
