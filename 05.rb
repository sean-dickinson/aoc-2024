module Day05
  class Update
    attr_reader :pages
    # @param string [String]
    def initialize(string)
      @pages = string.split(",").map(&:to_i)
    end

    def middle
      pages[middle_index]
    end

    private

    def middle_index
      (@pages.size / 2).ceil
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
      before_index = update.pages.find_index(@before)
      after_index = update.pages.find_index(@after)
      return true if before_index.nil? || after_index.nil?

      before_index < after_index
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
  end
  class << self
    def part_one(input)
      validator = Validator.from_input(input)
      validator.valid_updates.sum(&:middle)
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
