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

  Line = Data.define(:position_1, :position_2) do
    def slope
      delta = position_2 - position_1
      Rational(delta.row, delta.column)
    end

    def at(column)
      # Point slope form: y - y1 = m(x - x1)
      row = (slope * (column - position_1.column)) + position_1.row
      # We ignore values that are not integers since it doesn't fit the grid model
      if row != row.to_i
        nil
      else
        Position.new(row, column)
      end
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

    def in_line_with(position1, position2)
      line = Line.new(position1, position2)
      (0...columns)
        .map { |column| line.at(column) }
        .compact
        .select(&method(:include?))
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

    def resonant_harmonics
      grouped_antennas.inject(Set.new) do |result, group|
        result + harmonics_for_antennas(group)
      end
    end

    private

    def harmonics_for_antennas(group)
      group.combination(2).flat_map do |(antenna1, antenna2)|
        bounds.in_line_with(antenna1.position, antenna2.position)
      end
    end

    def grouped_antennas
      antennas
        .group_by(&:frequency)
        .values
        .reject { |group| group.size < 2 }
    end

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
      grid = GridFactory.new(input).grid
      grid.resonant_harmonics.size
    end
  end
end
