require "debug"
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

    def respond_to_missing?(method_name, include_private = false)
      is_combination_method?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      if is_combination_method?(method_name)
        *methods = method_name.to_s.split("_")
        methods.reduce(self) do |cell, method|
          cell.public_send(method)
        end
      else
        super
      end
    end

    private

    def is_combination_method?(method_name)
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

    def at(*cells)
      cells.map do |cell|
        if out_of_bounds?(cell)
          nil
        else
          @grid[cell.row][cell.column]
        end
      end
    end

    def where(value = nil)
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
    def start_with?(value)
      raise NotImplementedError, "Subclasses must implement this method"
    end

    def candidates_for(cell)
      raise NotImplementedError, "Subclasses must implement this method"
    end

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

    # @param cell [GridCell]
    def candidates_for(cell)
      directions.map do |direction|
        follow_directions(cell, directions_for_word(direction))
      end
    end

    def match?(values)
      values.compact.join == @word
    end

    private

    # @param cell [GridCell]
    # @param cell_methods [Array<Symbol>]
    # @return [Array<GridCell>]
    def follow_directions(cell, cell_methods)
      results = []
      current_cell = cell
      cell_methods.each do |method|
        current_cell = current_cell.public_send(method)
        results << current_cell
      end
      results
    end

    # @param direction [Symbol]
    # @return [Array<Symbol>]
    def directions_for_word(direction)
      [:stay, *Array.new(@word.size - 1).fill(direction)]
    end

    def directions
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
      raise NotImplementedError
    end
  end
end
