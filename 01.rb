module Day01

  class LocationPair
    attr_reader :first, :second
    def initialize(first, second)
      @first = first
      @second = second
    end

    def distance
      (@second - @first).abs
    end

    def ==(other)
      @first == other.first && @second == other.second
    end
  end

  class LocationPairList
    class << self
      def from_input(input)
        left_list, right_list = input.map { |line| line.split.map(&:to_i) }.transpose
        new(left_list, right_list)
      end
    end

    attr_reader :pairs

    def initialize(left_list, right_list)
      @pairs = create_pairs(left_list, right_list)
    end

    def total_distance
      @pairs.sum(&:distance)
    end

    def ==(other)
      @pairs == other.pairs
    end

    private

    # @param left_list [Array<Integer>]
    # @param right_list [Array<Integer>]
    def create_pairs(left_list, right_list)
      left_list.sort.zip(right_list.sort).map {|pair| LocationPair.new(*pair)}
    end
  end


  class << self
    def part_one(input)
      LocationPairList.from_input(input).total_distance
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
