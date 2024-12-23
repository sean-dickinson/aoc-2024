require "./06"
RSpec.describe Day06 do
  describe "Position" do
    it "is an object with an x and y coordinate" do
      pos = Day06::Position.new(1, 2)
      expect(pos).to be_a Day06::Position
      expect(pos.x).to eq 1
      expect(pos.y).to eq 2
    end

    it "behaves like a value object" do
      pos1 = Day06::Position.new(1, 2)
      pos2 = Day06::Position.new(1, 2)
      expect(pos1).to eq pos2
    end

    describe "#translate" do
      it "returns a new position with the x or y coordinate adjusted by 1" do
        pos = Day06::Position.new(1, 2)
        expect(pos.translate(:north)).to eq Day06::Position.new(1, 1)
        expect(pos.translate(:south)).to eq Day06::Position.new(1, 3)
        expect(pos.translate(:east)).to eq Day06::Position.new(2, 2)
        expect(pos.translate(:west)).to eq Day06::Position.new(0, 2)
      end
    end
  end

  describe "Guard" do
    it "is initialized with a position and a heading" do
      pos = Day06::Position.new(1, 2)
      guard = Day06::Guard.new(pos, :north)
      expect(guard).to be_a Day06::Guard
      expect(guard.position).to eq pos
      expect(guard.heading).to eq :north
    end

    context "#forward" do
      it "decrements the y position if facing north" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :north)
        guard.forward
        expect(guard.position).to eq Day06::Position.new(1, 1)
      end

      it "increments the y position if facing south" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :south)
        guard.forward
        expect(guard.position).to eq Day06::Position.new(1, 3)
      end

      it "increments the x position if facing east" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :east)
        guard.forward
        expect(guard.position).to eq Day06::Position.new(2, 2)
      end

      it "decrements the x position if facing west" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :west)
        guard.forward
        expect(guard.position).to eq Day06::Position.new(0, 2)
      end
    end

    context "#next_position" do
      it "returns the position the guard would move to if it moved forward, but does not move the guard" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :north)
        expect(guard.next_position).to eq Day06::Position.new(1, 1)
      end
    end

    context "#turn" do
      it "rotates the guard 90 degrees to the right, by updating the heading" do
        pos = Day06::Position.new(1, 2)
        guard = Day06::Guard.new(pos, :north)

        guard.turn
        expect(guard.heading).to eq :east
        guard.turn
        expect(guard.heading).to eq :south
        guard.turn
        expect(guard.heading).to eq :west
        guard.turn
        expect(guard.heading).to eq :north
      end
    end

    context "#visited_positions" do
      it "returns a list of all the positions the guard has visited" do
        pos = Day06::Position.new(1, 1)
        guard = Day06::Guard.new(pos, :north)

        expect(guard.visited_positions).to eq [pos]

        guard.forward
        expect(guard.visited_positions).to eq [pos, Day06::Position.new(1, 0)]

        guard.turn
        guard.forward
        expect(guard.visited_positions).to eq [pos, Day06::Position.new(1, 0), Day06::Position.new(2, 0)]
      end
    end
  end

  describe "MapBounds" do
    it "is initialized with a number of rows and columns" do
      bounds = Day06::MapBounds.new(3, 4)
      expect(bounds).to be_a Day06::MapBounds
      expect(bounds.rows).to eq 3
      expect(bounds.columns).to eq 4
    end

    context "#out_of_bounds?" do
      it "returns true if the both the x and y are outside the bounds" do
        bounds = Day06::MapBounds.new(3, 3)
        expect(bounds.out_of_bounds?(Day06::Position.new(3, 3))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(4, 4))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(-1, -1))).to be true
      end

      it "returns true if the x is outside the bounds" do
        bounds = Day06::MapBounds.new(3, 3)
        expect(bounds.out_of_bounds?(Day06::Position.new(3, 2))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(4, 2))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(-1, 2))).to be true
      end

      it "returns true if the y is outside the bounds" do
        bounds = Day06::MapBounds.new(3, 3)
        expect(bounds.out_of_bounds?(Day06::Position.new(2, 3))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(2, 4))).to be true
        expect(bounds.out_of_bounds?(Day06::Position.new(2, -1))).to be true
      end

      it "returns false if the position is within the bounds" do
        bounds = Day06::MapBounds.new(3, 3)
        expect(bounds.out_of_bounds?(Day06::Position.new(2, 2))).to be false
        expect(bounds.out_of_bounds?(Day06::Position.new(1, 1))).to be false
        expect(bounds.out_of_bounds?(Day06::Position.new(0, 0))).to be false
        expect(bounds.out_of_bounds?(Day06::Position.new(2, 0))).to be false
        expect(bounds.out_of_bounds?(Day06::Position.new(0, 2))).to be false
      end
    end
  end

  describe "Map" do
    it "initializes with a set of bounds,  obstacles and a guard" do
      bounds = Day06::MapBounds.new(3, 3)
      obstacles = [Day06::Position.new(0, 1)]
      guard = Day06::Guard.new(Day06::Position.new(2, 2), :north)
      map = Day06::Map.new(bounds:, obstacles:, guard:)

      expect(map).to be_a Day06::Map
      expect(map.bounds).to eq bounds
      expect(map.obstacles).to eq obstacles
      expect(map.guard).to eq guard
    end

    describe "#plot" do
      it "moves the guard until it is off the map" do
        map = Day06::MapFactory.new([
          "..#",
          "#..",
          "..^"
        ]).build
        map.plot
        expect(map.guard.position).to eq Day06::Position.new(2, 1)
        expect(map.guard.heading).to eq :east
        expect(map.guard.visited_positions).to eq [
          Day06::Position.new(2, 2),
          Day06::Position.new(2, 1)
        ]
      end
    end
  end

  describe "MapFactory" do
    it "creates a map from an array of strings" do
      map_factory = Day06::MapFactory.new([
        "..#",
        "#..",
        "..^"
      ])
      map = map_factory.build

      expect(map).to be_a Day06::Map
      expect(map.obstacles).to eq [Day06::Position.new(2, 0), Day06::Position.new(0, 1)]
      expect(map.guard.position).to eq Day06::Position.new(2, 2)
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/06.txt", chomp: true)
      expect(Day06.part_one(input)).to eq 41
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/06.txt", chomp: true)
      expect(Day06.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
