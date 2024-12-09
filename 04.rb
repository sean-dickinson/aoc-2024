module Day04
  GridCell = Data.define(:row, :column) do
    def up
      to(row - 1, column)
    end

    def down
      to(row + 1, column)
    end

    def left
      to(row, column - 1)
    end

    def right
      to(row, column + 1)
    end

    def stay
      to(row, column)
    end

    def relatives(*directions)
      directions.map do |direction|
        public_send(direction)
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      is_combination_method?(method_name) || super
    end

    # We accept methods that are a combination of existing methods separated by an underscore
    # For example, `up_right` is a valid method name
    def method_missing(method_name, *args, &block)
      return super unless is_combination_method?(method_name)

      *methods = method_name.to_s.split("_")
      methods.reduce(self) do |cell, method|
        cell.public_send(method)
      end
    end

    def to_s
      "(#{row}, #{column})"
    end

    def inspect
      to_s
    end

    private

    # Check if the method name is a combination of existing methods separated by an underscore
    def is_combination_method?(method_name)
      return false unless method_name.to_s.include?("_")
      method_name.to_s.split("_").all? { |m| respond_to?(m) }
    end

    def to(row, column)
      self.class.new(row, column)
    end
  end

  class Grid
    attr_reader :grid

    def initialize(grid)
      @grid = create_grid!(grid)
    end

    # @param cells [Array<GridCell>]
    # @return [Array<String>] the values of the grid cells, invalid cells will be returned as nil
    def at(*cells)
      cells.map do |cell|
        if out_of_bounds?(cell)
          nil
        else
          @grid[cell.row][cell.column]
        end
      end
    end

    # Accept either a value or a block,
    # returns all the grid cells that match the value
    # or if a block is given, when the block returns a truthy value
    # The block takes precedence over the value
    def where(value = nil)
      raise ArgumentError, "You can't pass both a value and a block" if !value.nil? && block_given?

      @grid.each_with_index.flat_map do |row, row_index|
        row.each_with_index.map do |cell, column_index|
          result = if block_given?
            yield(cell)
          else
            cell == value
          end
          GridCell.new(row_index, column_index) if result
        end
      end.compact
    end

    def rows
      @grid.size
    end

    def columns
      @grid.first.size
    end

    def size
      rows * columns
    end

    private

    def out_of_bounds?(grid_cell)
      grid_cell.row < 0 || grid_cell.column < 0 || grid_cell.row >= rows || grid_cell.column >= columns
    end

    # @param grid [Array<String>]
    # @return [Array<Array<String>>]
    def create_grid!(grid)
      grid.map(&:chars)
    end
  end

  class Pattern
    # @abstract
    # Check if the value given is the start of the pattern
    # @param value [String]
    # @return [Boolean]
    def start_with?(value)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    # Given a starting cell, return a list of cells that are candidates for the pattern
    # @param cell [GridCell]
    # @return [Array<Array<GridCell>>]
    def candidates_for(cell)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    # @abstract
    # Check if the values given match the pattern
    # @param values [Array<String | nil>]
    # @return [Boolean]
    def match?(values)
      raise NotImplementedError, "Subclasses must implement this method"
    end
  end

  class WordPattern < Pattern
    def initialize(word)
      @word = word
    end

    def start_with?(value)
      value == @word[0]
    end

    def candidates_for(cell)
      search_directions.map do |direction|
        cell.relatives(*direction_list_for(direction))
      end
    end

    def match?(values)
      values.compact.join == @word
    end

    private

    # We want to search linearly in a direction,
    # This method returns the directions to give to the starting cell,
    # to get all the cells in the direction we want to search
    def direction_list_for(direction)
      [:stay, *relatives(direction)]
    end

    def search_directions
      [
        :right,
        :left,
        :up,
        :down,
        :up_right,
        :down_right,
        :up_left,
        :down_left
      ]
    end

    def relatives(direction)
      1.upto(@word.size - 1).map do |i|
        ([direction] * i).join("_")
      end
    end
  end

  class XMasPattern < Pattern
    def start_with?(value)
      value == "A"
    end

    def candidates_for(cell)
      [cell.relatives(*directions)]
    end

    def match?(values)
      matching_values.include?(values.compact.join)
    end

    private

    def matching_values
      [
        "MAS" * 2,
        "MAS".reverse * 2,
        "MAS" + "MAS".reverse,
        "MAS".reverse + "MAS"
      ]
    end

    def directions
      diagonal_down_right + diagonal_down_left
    end

    def diagonal_down_right
      [:up_left, :stay, :down_right]
    end

    def diagonal_down_left
      [:up_right, :stay, :down_left]
    end
  end

  class WordSearch
    def initialize(grid, pattern)
      @grid = grid
      @pattern = pattern
    end

    def count
      starting_cells.sum do |cell|
        @pattern.candidates_for(cell).count do |candidate_cells|
          @pattern.match?(@grid.at(*candidate_cells))
        end
      end
    end

    private

    def starting_cells
      @grid.where do |value|
        @pattern.start_with?(value)
      end
    end
  end

  class << self
    def part_one(input)
      grid = Grid.new(input)
      search = WordSearch.new(grid, WordPattern.new("XMAS"))
      search.count
    end

    def part_two(input)
      grid = Grid.new(input)
      search = WordSearch.new(grid, XMasPattern.new)
      search.count
    end
  end
end
