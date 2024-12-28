module Day07
  Equation = Data.define(:solution, :terms, :operators) do
    class << self
      def from_string(input)
        solution, *terms = input.split(":")
        terms = terms.first.split.map(&:to_i)
        new(solution: solution.to_i, terms: terms)
      end
    end

    def initialize(solution:, terms:, operators: %i[+ *])
      super(solution:, terms:, operators:)
    end

    def valid?
      operators.any? { |operator| operator_valid?(operator) }
    end

    private

    def operator_valid?(operator)
      if terms.size > 2
        with(terms: simplified_terms(operator)).valid?
      else
        terms.reduce(operator) == solution
      end
    end

    def simplified_terms(operator)
      first, second, *rest = terms
      combined = [first, second].reduce(operator)
      [combined, *rest]
    end
  end

  class << self
    def part_one(input)
      input.map { |line| Equation.from_string(line) }.select(&:valid?).sum(&:solution)
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end