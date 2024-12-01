module Day01
  LocationPair = Data.define(:first, :second) do
    def distance
      (second - first).abs
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
      @left_list = left_list
      @right_list = right_list
      @pairs = create_pairs(left_list, right_list)
    end

    def total_distance
      pairs.sum(&:distance)
    end

    def similarity_score
      right_tally = @right_list.tally
      @left_list.sum { |location| location * right_tally.fetch(location, 0) }
    end

    def ==(other)
      pairs == other.pairs
    end

    private

    # @param left_list [Array<Integer>]
    # @param right_list [Array<Integer>]
    def create_pairs(left_list, right_list)
      left_list.sort.zip(right_list.sort).map { |pair| LocationPair.new(*pair) }
    end
  end

  class << self
    def part_one(input)
      LocationPairList.from_input(input).total_distance
    end

    def part_two(input)
      LocationPairList.from_input(input).similarity_score
    end
  end
end
