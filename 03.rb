module Day03
  Multiplier = Data.define(:x, :y) do
    def result
      x * y
    end
  end

  class MultiplierParser
    # @param input [String]
    def initialize(input)
      @input = input
    end

    # @return [Array<Multiplier>]
    def parse
      result = []
      @input.scan(/mul\((\d{1,3}),(\d{1,3})\)/) do |x, y|
        result << Multiplier.new(x.to_i, y.to_i)
      end
      result
    end
  end
  class << self
    def part_one(input)
      MultiplierParser.new(input.join).parse.sum(&:result)
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
