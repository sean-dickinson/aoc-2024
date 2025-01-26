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

    def blink(iterations = 1)
      stones.map do |stone|
        stone.blink(iterations)
      end.inject(:+)
    end
  end

  Stone = Data.define(:number) do
    @cache = {}

    class << self
      def get_closet_iteration_for(stone, iteration)
        @cache[stone] ||= [stone.blink]
        iteration_index = iteration - 1
        value = @cache[stone][iteration_index]
        return [iteration, value] unless value.nil?

        @cache[stone] << @cache[stone].last.blink
        highest_iteration_for(stone)
      end

      private

      def highest_iteration_for(stone)
        [
          @cache[stone].size,
          @cache[stone].last
        ]
      end
    end

    def +(other)
      if other.is_a? Stone
        StoneCollection.from_numbers([number, other.number])
      elsif other.is_a? StoneCollection
        StoneCollection.from_numbers([number]) + other
      else
        raise ArgumentError, "Can only add a Stone or a StoneCollection"
      end
    end

    def blink(iterations = 1)
      return base_blink if iterations == 1
      iteration, value = get_closest_iteration_to(iterations)
      if iteration == iterations
        value
      else
        value.blink(iterations - iteration)
      end
    end

    private

    def get_closest_iteration_to(iteration)
      self.class.get_closet_iteration_for(self, iteration)
    end

    def base_blink
      return with(number: 1) if number.zero?

      if digit_count.even?
        StoneCollection.from_numbers(split_number)
      else
        with(number: number * 2024)
      end
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
      StoneCollection.from_numbers(@input.split.map(&:to_i))
    end
  end

  class << self
    def part_one(input)
      stones = StoneFactory.new(input.first).create!
      stones.blink(25).size
    end

    def part_two(input)
      stones = StoneFactory.new(input.first).create!
      stones.blink(35).size
    end
  end
end
