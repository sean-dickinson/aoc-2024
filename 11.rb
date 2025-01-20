module Day11
  Stone = Data.define(:number) do
    def blink
      return with(number: 1) if number.zero?

      if digit_count.even?
        split_number.map { |num| with(number: num) }
      else
        with(number: number * 2024)
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
      @input.split.map { |number| Stone.new(number.to_i) }
    end
  end

  class << self
    def part_one(input)
      stones = StoneFactory.new(input.first).create!
      25.times do
        stones = stones.flat_map(&:blink)
      end
      stones.size
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
