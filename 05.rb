require "forwardable"
module Day05
  class Update
    attr_reader :pages
    extend Forwardable
    def_delegators :@pages, :eql?, :find_index
    # @param string [String]
    def initialize(string)
      @pages = string.split(",").map(&:to_i)
    end

    def middle
      pages[middle_index]
    end

    private

    def middle_index
      (pages.size / 2).ceil
    end
  end

  class Rule
    # @param string [String]
    def initialize(string)
      @before, @after = string.split("|").map(&:to_i)
    end

    # @param update [Update]
    # @return [Boolean]
    def valid?(update)
      before_index, after_index = indicies(update)
      return true if before_index.nil? || after_index.nil?

      before_index < after_index
    end

    # @param update [Update]
    # @return [Update]
    def correct(update)
      return update if valid?(update)

      before_index, after_index = indicies(update)
      Update.new(swap(update.pages, before_index, after_index).join(","))
    end

    private

    def swap(pages, before_index, after_index)
      pages[before_index], pages[after_index] = pages[after_index], pages[before_index]
      pages
    end

    def indicies(update)
      [update.find_index(@before), update.find_index(@after)]
    end
  end

  class Validator
    class << self
      def from_input(lines)
        rules = []
        updates = []
        is_rule = true
        lines.each do |line|
          if line.empty?
            is_rule = false
            next
          end
          if is_rule
            rules << Rule.new(line)
          else
            updates << Update.new(line)
          end
        end
        new(rules, updates)
      end
    end

    attr_reader :rules, :updates
    # @param rules [Array<Rule>]
    # @param updates [Array<Update>]

    def initialize(rules, updates)
      @rules = rules
      @updates = updates
    end

    def valid_updates
      @updates.select do |update|
        @rules.all? { |rule| rule.valid?(update) }
      end
    end

    def corrected_updates
      invalid_updates.map do |update|
        corrected_update = correct_update(update) until @rules.all? { |rule| rule.valid?(update) }
        corrected_update
      end
    end

    private

    def correct_update(update)
      @rules.inject(update) do |corrected_update, rule|
        rule.correct(corrected_update)
      end
    end

    def invalid_updates
      @updates - valid_updates
    end
  end

  class << self
    def part_one(input)
      validator = Validator.from_input(input)
      validator.valid_updates.sum(&:middle)
    end

    def part_two(input)
      validator = Validator.from_input(input)
      validator.corrected_updates.sum(&:middle)
    end
  end
end
