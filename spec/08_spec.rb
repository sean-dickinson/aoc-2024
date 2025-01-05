require "./08"
RSpec.describe Day08 do
  describe "Position" do
    it "is created with a row and column" do
      position = Day08::Position.new(3, 4)
      expect(position.row).to eq 3
      expect(position.column).to eq 4
    end

    describe "#-" do
      it "returns a new position with the difference of the rows and columns" do
        position = Day08::Position.new(3, 4)
        other_position = Day08::Position.new(1, 2)
        expect(position - other_position).to eq Day08::Position.new(2, 2)
      end

      it "handles negative results" do
        position = Day08::Position.new(3, 4)
        other_position = Day08::Position.new(1, 5)
        expect(position - other_position).to eq Day08::Position.new(2, -1)
      end
    end

    describe "#+" do
      it "returns a new position with the sum of the rows and columns" do
        position = Day08::Position.new(3, 4)
        other_position = Day08::Position.new(1, 2)
        expect(position + other_position).to eq Day08::Position.new(4, 6)
      end

      it "handles negatives" do
        position = Day08::Position.new(3, 4)
        other_position = Day08::Position.new(-1, -2)
        expect(position + other_position).to eq Day08::Position.new(2, 2)
      end
    end
  end

  describe "Antenna" do
    it "is created with a position and a frequency" do
      position = Day08::Position.new(3, 4)
      antenna = Day08::Antenna.new(position, "a")
      expect(antenna.position).to eq position
      expect(antenna.frequency).to eq "a"
    end

    describe "#antinodes_for" do
      context "different frequencies" do
        it "returns an empty array if the other antenna is a different frequency" do
          position = Day08::Position.new(3, 4)
          antenna = Day08::Antenna.new(position, "a")
          other_antenna = Day08::Antenna.new(position, "B")
          expect(antenna.antinodes_for(other_antenna)).to eq []
        end
      end
      context "same frequencies" do
        it "returns the correct positions when the antennas are 1 step away from each other" do
          position = Day08::Position.new(3, 4)
          antenna = Day08::Antenna.new(position, "a")
          other_antenna = antenna.with(position: Day08::Position.new(4, 5)) # 1 right and 1 down
          expect(antenna.antinodes_for(other_antenna)).to eq [
            Day08::Position.new(5, 6),
            Day08::Position.new(2, 3)
          ]
        end

        it "returns the correct positions when the antennas are 2 rows away from each other" do
          position = Day08::Position.new(3, 4)
          antenna = Day08::Antenna.new(position, "a")
          other_antenna = antenna.with(position: Day08::Position.new(5, 5)) # 1 right, 2 down
          expect(antenna.antinodes_for(other_antenna)).to eq [
            Day08::Position.new(7, 6),
            Day08::Position.new(1, 3)
          ]
        end

        it "returns the correct positions when the antennas are 3 columns away from each other" do
          position = Day08::Position.new(4, 8)
          antenna = Day08::Antenna.new(position, "a")
          other_antenna = antenna.with(position: Day08::Position.new(5, 5)) # 3 left, 1 down
          expect(antenna.antinodes_for(other_antenna)).to eq [
            Day08::Position.new(6, 2),
            Day08::Position.new(3, 11)
          ]
        end
      end
    end
  end

  describe "GridBounds" do
    it "is created with number of rows and columns" do
      bounds = Day08::GridBounds.new(3, 4)
      expect(bounds.rows).to eq 3
      expect(bounds.columns).to eq 4
    end
    describe "#include?" do
      it "returns false if the position is not inside the bounds" do
        bounds = Day08::GridBounds.new(3, 4)
        out_of_bounds = [
          Day08::Position.new(-1, 0),
          Day08::Position.new(0, -1),
          Day08::Position.new(3, 0),
          Day08::Position.new(0, 4),
          Day08::Position.new(4, 5)
        ]
        out_of_bounds.each do |position|
          expect(bounds.include?(position)).to be false
        end
      end
      it "returns true if the position is inside the bounds" do
        bounds = Day08::GridBounds.new(3, 4)
        in_bounds = [
          Day08::Position.new(0, 0),
          Day08::Position.new(2, 3)
        ]
        in_bounds.each do |position|
          expect(bounds.include?(position)).to be true
        end
      end
    end
  end
  describe "Grid" do
    it "is created with bounds and a set of antennas" do
      bounds = Day08::GridBounds.new(10, 10)
      antennas = [
        Day08::Antenna.new(Day08::Position.new(3, 4), "a"),
        Day08::Antenna.new(Day08::Position.new(5, 6), "a")
      ]
      grid = Day08::Grid.new(bounds, antennas)
      expect(grid.bounds).to eq bounds
      expect(grid.antennas).to contain_exactly(*antennas)
    end

    describe "#antinodes" do
      it "returns a set of the positions of the antinodes" do
        bounds = Day08::GridBounds.new(10, 10)
        antennas = [
          Day08::Antenna.new(Day08::Position.new(3, 4), "a"),
          Day08::Antenna.new(Day08::Position.new(5, 5), "a")
        ]
        grid = Day08::Grid.new(bounds, antennas)
        expect(grid.antinodes.to_a).to contain_exactly(
          Day08::Position.new(1, 3),
          Day08::Position.new(7, 6)
        )
      end
    end
  end

  describe "GridFactory" do
    it "parses the input into a Grid" do
      input = %w[
        ..........
        ..........
        ..........
        ....a.....
        ..........
        .....a....
        ..........
        ..........
        ..........
        ..........
      ]
      grid = Day08::GridFactory.new(input).grid
      expect(grid.bounds).to eq Day08::GridBounds.new(10, 10)
      expect(grid.antennas).to contain_exactly(
        Day08::Antenna.new(Day08::Position.new(3, 4), "a"),
        Day08::Antenna.new(Day08::Position.new(5, 5), "a")
      )
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/08.txt", chomp: true)
      expect(Day08.part_one(input)).to eq 14
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/08.txt", chomp: true)
      expect(Day08.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
