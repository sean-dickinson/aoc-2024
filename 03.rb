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
      @input.scan(pattern).flat_map do |x, y|
        Multiplier.new(x.to_i, y.to_i)
      end
    end

    private

    def pattern
      /mul\((\d{1,3}),(\d{1,3})\)/
    end
  end

  class ConditionalFragmentParser
    def initialize(input)
      @input = input
    end

    def parse
      normalized_input.scan(pattern).flat_map do |fragment|
        MultiplierParser.new(fragment.join).parse
      end
    end

    private

    def pattern
      /do\(\)(.*?)don't\(\)/
    end

    def normalized_input
      "do()" + @input + "don't()"
    end
  end

  class << self
    def part_one(input)
      MultiplierParser.new(input.join).parse.sum(&:result)
    end

    def part_two(input)
      ConditionalFragmentParser.new(input.join).parse.sum(&:result)
    end
  end
end
