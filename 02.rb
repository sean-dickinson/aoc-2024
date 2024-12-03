module Day02
  class Report
    class << self
      def from_string(string)
        new(*string.split.map(&:to_i))
      end
    end

    attr_reader :levels
    def initialize(*levels)
      @levels = levels
    end

    def safe?
      all_within_limit? && (all_negative? || all_positive?)
    end

    private

    def all_within_limit?
      diffs.all? { |diff| diff.abs > 0 && diff.abs <= limit }
    end

    def diffs
      levels.each_cons(2).map { |a, b| a - b }
    end

    def all_negative?
      diffs.all? { |diff| diff < 0 }
    end

    def all_positive?
      diffs.all? { |diff| diff > 0 }
    end

    def limit
      3
    end
  end
  class << self
    def part_one(input)
      input.map { |line| Report.from_string(line) }.count(&:safe?)
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
