# frozen_string_literal: true

module Day06
  HEADINGS = %i[north east south west].freeze

  Position = Data.define(:x, :y) do
    def translate(direction)
      case direction
      when :north
        with(y: y - 1)
      when :south
        with(y: y + 1)
      when :east
        with(x: x + 1)
      when :west
        with(x: x - 1)
      else
        raise ArgumentError, "Invalid direction: #{direction}"
      end
    end
  end

  GuardVisit = Data.define(:position, :heading)

  class Guard
    class << self
      def from_guard_visit(guard_visit)
        new(guard_visit.position, guard_visit.heading)
      end
    end

    attr_reader :position, :heading

    def initialize(position, heading)
      @position = position
      @heading = heading
      @visits = Set.new
      @is_stuck = false
      record_visit!
    end

    def stuck?
      @is_stuck
    end

    def next_position
      @position.translate(@heading)
    end

    def forward
      @position = next_position
      record_visit!
    end

    def turn
      current_index = HEADINGS.index(@heading)
      @heading = HEADINGS.rotate(1)[current_index]
      record_visit!
    end

    def visited_positions
      @visits.map(&:position).uniq
    end

    def dup
      self.class.new(@position, @heading)
    end

    private

    def record_visit!
      if @visits.include?(current_visit)
        @is_stuck = true
      end
      @visits << current_visit
    end

    def current_visit
      GuardVisit.new(@position, @heading)
    end
  end

  MapBounds = Data.define(:rows, :columns) do
    def out_of_bounds?(position)
      position.x.negative? || position.x >= columns || position.y.negative? || position.y >= rows
    end
  end

  class Map
    attr_reader :bounds, :obstacles, :initial_guard

    def initialize(bounds:, obstacles:, guard_visit:)
      @bounds = bounds
      @obstacles = obstacles
      @initial_guard = guard_visit
    end

    def plot
      guard = Guard.from_guard_visit(@initial_guard)
      until @bounds.out_of_bounds?(guard.next_position) || guard.stuck?
        move_guard(guard)
      end
      guard
    end

    private

    def move_guard(guard)
      if @obstacles.include?(guard.next_position)
        guard.turn
      else
        guard.forward
      end
    end
  end

  class MapFactory
    def initialize(input)
      @input = input
    end

    def build
      Map.new(bounds:, obstacles: Set.new(obstacles), guard_visit:)
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

    def guard_visit
      input_value_and_positions do |cell, position|
        return GuardVisit.new(position, heading_mappings[cell]) if heading_mappings[cell]
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

  class ScenarioRunner
    def initialize(map)
      @map = map
      @candidates = candidate_positions
    end

    def trap_positions
      @candidates.count do |position|
        is_trapped?(position)
      end
    end

    private

    def is_trapped?(position)
      guard = map_with_obstacle(position).plot
      guard.stuck?
    end

    def map_with_obstacle(position)
      obstacles = @map.obstacles | [position]
      Map.new(bounds: @map.bounds, obstacles:, guard_visit: @map.initial_guard)
    end

    def candidate_positions
      @map.plot.visited_positions - [@map.initial_guard.position]
    end
  end

  class << self
    def part_one(input)
      map = MapFactory.new(input).build
      map.plot.visited_positions.size
    end

    def part_two(input)
      map = MapFactory.new(input).build
      runner = ScenarioRunner.new(map)
      runner.trap_positions
    end
  end
end
