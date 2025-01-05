module Day08
  Position = Data.define(:row, :column) do
    def +(other)
      Position.new(row + other.row, column + other.column)
    end

    def -(other)
      Position.new(row - other.row, column - other.column)
    end
  end

  Antenna = Data.define(:position, :frequency) do
    def antinodes_for(other)
      return [] unless frequency == other.frequency

      relative_position = other.position - position
      [
        other.position + relative_position,
        position - relative_position
      ]
    end
  end

  GridBounds = Data.define(:rows, :columns) do
    def include?(position)
      [
        position.row >= 0,
        position.column >= 0,
        position.row < rows,
        position.column < columns
      ].all?
    end
  end

  class Grid
    attr_reader :bounds, :antennas

    def initialize(bounds, antennas)
      @bounds = bounds
      @antennas = Set.new(antennas)
    end

    def antinodes
      antennas.inject(Set.new) do |result, antenna|
        result + antinodes_for(antenna)
      end
    end

    private

    def antinodes_for(antenna)
      antennas.inject([]) do |results, other|
        if other == antenna
          results
        else
          results + antenna.antinodes_for(other).reject(&method(:out_of_bounds?))
        end
      end
    end

    def out_of_bounds?(position)
      !bounds.include?(position)
    end
  end

  class GridFactory
    def initialize(input)
      @input = input
    end

    def grid
      Grid.new(bounds, antennas)
    end

    private

    def bounds
      rows = @input.size
      columns = @input.first.size
      GridBounds.new(rows, columns)
    end

    def antennas
      @input.each_with_index.flat_map do |row, row_index|
        row.chars.each_with_index.map do |frequency, column_index|
          next if frequency == "."
          Antenna.new(Position.new(row_index, column_index), frequency)
        end
      end.compact
    end
  end

  class << self
    def part_one(input)
      grid = GridFactory.new(input).grid
      grid.antinodes.size
    end

    def part_two(input)
      raise NotImplementedError
    end
  end
end
