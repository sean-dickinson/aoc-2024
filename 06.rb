# frozen_string_literal: true

module Day06
  HEADINGS = %i[north east south west].freeze

  Position = Data.define(:x, :y) do
    def translate(direction)
      case direction
      when :north
        Position.new(x, y - 1)
      when :south
        Position.new(x, y + 1)
      when :east
        Position.new(x + 1, y)
      when :west
        Position.new(x - 1, y)
      else
        raise ArgumentError, "Invalid direction: #{direction}"
      end
    end
  end

  class Guard
    attr_reader :position, :heading

    def initialize(position, heading)
      @position = position
      @heading = heading
      @visited_positions = Set.new
      record_position!
    end

    def next_position
      @position.translate(@heading)
    end

    def forward
      @position = next_position
      record_position!
    end

    def turn
      current_index = HEADINGS.index(@heading)
      new_index = (current_index + 1) % HEADINGS.length
      @heading = HEADINGS[new_index]
    end

    def visited_positions
      @visited_positions.to_a
    end

    private

    def record_position!
      @visited_positions << @position
    end
  end

  MapBounds = Data.define(:rows, :columns) do
    def out_of_bounds?(position)
      position.x.negative? || position.x >= columns || position.y.negative? || position.y >= rows
    end
  end

  class Map
    attr_reader :bounds, :obstacles, :guard

    def initialize(bounds:, obstacles:, guard:)
      @bounds = bounds
      @obstacles = obstacles
      @guard = guard
    end

    def plot
      until @bounds.out_of_bounds?(@guard.next_position)
        if @obstacles.include?(@guard.next_position)
          @guard.turn
        else
          @guard.forward
        end
      end
    end
  end

  class MapFactory
    def initialize(input)
      @input = input
    end

    def build
      Map.new(bounds:, obstacles:, guard:)
    end

    private

    def bounds
      MapBounds.new(@input.size, @input.first.size)
    end

    def obstacles
      input_value_and_positions do |cell, position|
        position if cell == "#"
      end.compact
    end

    def guard
      input_value_and_positions do |cell, position|
        return Guard.new(position, heading_mappings[cell]) if heading_mappings.key?(cell)
      end
    end

    def input_value_and_positions
      @input.each_with_index.flat_map do |row, y|
        row.chars.each_with_index.map do |cell, x|
          yield(cell, Position.new(x, y))
        end
      end
    end

    def heading_mappings
      {
        "^" => :north,
        ">" => :east,
        "v" => :south,
        "<" => :west
      }
    end
  end

  class << self
    def part_one(input)
      map = MapFactory.new(input).build
      map.plot
      map.guard.visited_positions.size
    end

    def part_two(input)
      # get options via the positions from part 1 - starting position
      # try adding an obstacle for each one and run the plot
      # if the guard leaves the bounds, we reject it
      # TODO: figure out how to end early for a loop so we don't end up in a stack overflow
      raise NotImplementedError
    end
  end
end
