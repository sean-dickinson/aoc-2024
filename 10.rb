module Day10
  GridCell = Data.define(:row, :column)
  Position = Data.define(:grid_cell, :height) do
    def trailhead? = height == 0

    def hikeable?(other) = (other.height - height) == 1

    def peak? = height == 9

    def to_s
      "Row: #{grid_cell.row}, Column: #{grid_cell.column}, Height: #{height}"
    end
  end

  GridBounds = Data.define(:rows, :columns) do
    def valid_position?(grid_cell)
      [
        grid_cell.row >= 0,
        grid_cell.row < rows,
        grid_cell.column >= 0,
        grid_cell.column < columns
      ].all?
    end

    def neighbors_for(grid_cell)
      [
        grid_cell.with(row: grid_cell.row - 1),
        grid_cell.with(row: grid_cell.row + 1),
        grid_cell.with(column: grid_cell.column - 1),
        grid_cell.with(column: grid_cell.column + 1)
      ].select { |cell| valid_position?(cell) }
    end
  end

  class MapFactory
    def initialize(input)
      @input = input
    end

    def create!
      Map.new(cells:, bounds:)
    end

    private

    def bounds
      GridBounds.new(rows: @input.size, columns: @input.first.size)
    end

    def cells
      @input.flat_map.with_index do |row, row_index|
        row.chars.each_with_index.flat_map do |height, column_index|
          create_position!(row: row_index, column: column_index, height: height)
        end
      end
    end

    def create_position!(row:, column:, height:)
      grid_cell = GridCell.new(row:, column:)
      # For the examples we want to ignore these positions
      if height == "."
        Position.new(height: -1, grid_cell:)
      else
        Position.new(height: height.to_i, grid_cell:)
      end
    end
  end

  class Map
    attr_reader :cells

    def initialize(cells:, bounds:)
      @cells = cells.group_by(&:grid_cell).transform_values(&:first)
      @bounds = bounds
    end

    def trailheads
      @cells.values.flatten.select(&:trailhead?)
    end

    def trailhead_scores
      trailheads.map do |trailhead|
        peaks_from(trailhead).uniq.size
      end
    end

    def trailhead_ratings
      trailheads.map do |trailhead|
        peaks_from(trailhead).size
      end
    end

    private

    def at(cell)
      @cells[cell]
    end

    def peaks_from(current_position)
      return current_position if current_position.peak?

      neighbors_for(current_position).map do |neighbor|
        if current_position.hikeable?(neighbor)
          peaks_from(neighbor)
        end
      end.flatten.compact
    end

    def neighbors_for(position)
      @bounds.neighbors_for(position.grid_cell).map(&method(:at))
    end
  end

  class << self
    def part_one(input)
      map = MapFactory.new(input).create!
      map.trailhead_scores.sum
    end

    def part_two(input)
      map = MapFactory.new(input).create!
      map.trailhead_ratings.sum
    end
  end
end
