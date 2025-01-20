require "./10"
RSpec.describe Day10 do
  describe Day10::Position do
    describe "#hikeable?" do
      let(:grid_cell) { Day10::GridCell.new(row: 0, column: 0) }
      it "returns true if the given position has a height that is exactly 1 more than its height" do
        position = Day10::Position.new(grid_cell:, height: 3)
        expect(position.hikeable?(Day10::Position.new(grid_cell: grid_cell.with(row: 1), height: 4))).to be true
      end

      it "returns false if the given position has a height that is more than 1 more than its height" do
        position = Day10::Position.new(grid_cell:, height: 3)
        expect(position.hikeable?(Day10::Position.new(grid_cell: grid_cell.with(row: 1), height: 5))).to be false
      end

      it "returns false if the given position has a height that is less than its height" do
        position = Day10::Position.new(grid_cell:, height: 3)
        expect(position.hikeable?(Day10::Position.new(grid_cell: grid_cell.with(row: 1), height: 2))).to be false
      end

      it "returns false if the given position is the same height" do
        position = Day10::Position.new(grid_cell:, height: 3)
        expect(position.hikeable?(Day10::Position.new(grid_cell: grid_cell.with(row: 1), height: 3))).to be false
      end
    end

    describe "#trailhead?" do
      let(:grid_cell) { Day10::GridCell.new(row: 0, column: 0) }
      it "is true if the position has a height of 0" do
        position = Day10::Position.new(grid_cell:, height: 0)
        expect(position).to be_trailhead
      end

      it "is false if the position has a height greater than 0" do
        position = Day10::Position.new(grid_cell:, height: 1)
        expect(position).not_to be_trailhead
      end
    end
  end

  describe Day10::MapFactory do
    it "creates a map from a list of strings" do
      input = %w[0123 1234 8765 9876]
      map_factory = Day10::MapFactory.new(input)
      map = map_factory.create!

      expect(map).to be_a Day10::Map
      expect(map.cells).to have(16).items

      expect(map.cells.values).to include(
        # Row 0
        Day10::Position.new(Day10::GridCell.new(row: 0, column: 0), 0),
        Day10::Position.new(Day10::GridCell.new(row: 0, column: 1), 1),
        Day10::Position.new(Day10::GridCell.new(row: 0, column: 2), 2),
        Day10::Position.new(Day10::GridCell.new(row: 0, column: 3), 3),
        # Row 1
        Day10::Position.new(Day10::GridCell.new(row: 1, column: 0), 1),
        Day10::Position.new(Day10::GridCell.new(row: 1, column: 1), 2),
        Day10::Position.new(Day10::GridCell.new(row: 1, column: 2), 3),
        Day10::Position.new(Day10::GridCell.new(row: 1, column: 3), 4),
        # Row 2
        Day10::Position.new(Day10::GridCell.new(row: 2, column: 0), 8),
        Day10::Position.new(Day10::GridCell.new(row: 2, column: 1), 7),
        Day10::Position.new(Day10::GridCell.new(row: 2, column: 2), 6),
        Day10::Position.new(Day10::GridCell.new(row: 2, column: 3), 5),
        # Row 3
        Day10::Position.new(Day10::GridCell.new(row: 3, column: 0), 9),
        Day10::Position.new(Day10::GridCell.new(row: 3, column: 1), 8),
        Day10::Position.new(Day10::GridCell.new(row: 3, column: 2), 7),
        Day10::Position.new(Day10::GridCell.new(row: 3, column: 3), 6)
      )

      expect(map.trailheads).to have(1).items
      expect(map.trailheads).to contain_exactly(Day10::Position.new(Day10::GridCell.new(row: 0, column: 0), 0))
    end
  end

  describe Day10::Map do
    describe "#trailhead_scores" do
      it "returns 2 if the trailhead has 2 paths that reach 9" do
        input = %w[
          ...0...
          ...1...
          ...2...
          6543456
          7.....7
          8.....8
          9.....9
        ]
        map_factory = Day10::MapFactory.new(input)
        map = map_factory.create!
        expect(map.trailhead_scores).to eq [2]
      end

      it "returns 4 when the trailhead has 4 paths that reach 9" do
        input = %w[
          ..90..9
          ...1.98
          ...2..7
          6543456
          765.987
          876....
          987....
        ]
        map_factory = Day10::MapFactory.new(input)
        map = map_factory.create!
        expect(map.trailhead_scores).to eq [4]
      end

      it "returns 1 and 2 for 2 trailheads with these respective scores" do
        input = %w[
          10..9..
          2...8..
          3...7..
          4567654
          ...8..3
          ...9..2
          .....01
        ]
        map_factory = Day10::MapFactory.new(input)
        map = map_factory.create!

        expect(map.trailhead_scores).to contain_exactly(1, 2)
      end
    end

    describe "#trailhead_ratings" do
      it "returns 3 if the trailhead has 3 distinct trails" do
        input = %w[
          .....0.
          ..4321.
          ..5..2.
          ..6543.
          ..7..4.
          ..8765.
          ..9....
        ]

        map = Day10::MapFactory.new(input).create!

        expect(map.trailhead_ratings).to eq [3]
      end

      it "returns 13 if the trailhead has 13 distinct trails" do
        input = %w[
          ..90..9
          ...1.98
          ...2..7
          6543456
          765.987
          876....
          987....
        ]

        map = Day10::MapFactory.new(input).create!

        expect(map.trailhead_ratings).to eq [13]
      end

      it "returns 227 when the trailhead has 121 trails to one peak and 106 to another peak" do
        input = %w[
          012345
          123456
          234567
          345678
          4.6789
          56789.
        ]
        map = Day10::MapFactory.new(input).create!

        expect(map.trailhead_ratings).to eq [227]
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/10.txt", chomp: true)
      expect(Day10.part_one(input)).to eq 36
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/10.txt", chomp: true)
      expect(Day10.part_two(input)).to eq 81
    end
  end
end
