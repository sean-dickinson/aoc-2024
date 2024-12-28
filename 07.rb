module Day07
  # Yeah, I'm re-opening the Integer class to add behavior to it.
  class ::Integer
    # || is reserved in Ruby, so I'm using | instead to represent concatenation
    def |(other)
      "#{self}#{other}".to_i
    end
  end

  Equation = Data.define(:solution, :terms, :additional_operators) do
    class << self
      def from_string(input, additional_operators: [])
        solution, *terms = input.split(":")
        terms = terms.first.split.map(&:to_i)
        new(solution: solution.to_i, terms:, additional_operators:)
      end
    end

    # Data is a bit funky, to apply defaults I need to override the #initialize method and supply the defaults there
    def initialize(solution:, terms:, additional_operators: [])
      super(solution:, terms:, additional_operators:)
    end

    def operators = %i[+ *] + additional_operators

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
      input.map { |line| Equation.from_string(line, additional_operators: [:|]) }.select(&:valid?).sum(&:solution)
    end
  end
end
