require "./04"
RSpec.describe Day04 do
  describe "GridCell" do
    it "has a row and a column" do
      cell = Day04::GridCell.new(0, 0)
      expect(cell.row).to eq 0
      expect(cell.column).to eq 0
    end

    it "can be moved up" do
      cell = Day04::GridCell.new(1, 1)
      expect(cell.up).to eq Day04::GridCell.new(0, 1)
    end

    it "can be moved down" do
      cell = Day04::GridCell.new(1, 1)
      expect(cell.down).to eq Day04::GridCell.new(2, 1)
    end

    it "can be moved left" do
      cell = Day04::GridCell.new(1, 1)
      expect(cell.left).to eq Day04::GridCell.new(1, 0)
    end

    it "can be moved right" do
      cell = Day04::GridCell.new(1, 1)
      expect(cell.right).to eq Day04::GridCell.new(1, 2)
    end

    it "can be moved up and left at the same time" do
      cell = Day04::GridCell.new(1, 1)
      expect(cell.up_left).to eq Day04::GridCell.new(0, 0)
    end
  end

  describe "Grid" do
    it "can be initialized with an array of strings" do
      grid = Day04::Grid.new([
        "AB",
        "DA",
        "CD"
      ])

      expect(grid).to be_a Day04::Grid
      expect(grid.rows).to eq 3
      expect(grid.columns).to eq 2
      expect(grid.size).to eq 6
    end

    context "#at" do
      it "returns the correct value at a given GridCell" do
        grid = Day04::Grid.new([
          "AB"
        ])
        expect(grid.at(Day04::GridCell.new(0, 0))).to eq ["A"]
        expect(grid.at(Day04::GridCell.new(0, 1))).to eq ["B"]
      end

      it "returns nil if the GridCell is out of bounds" do
        grid = Day04::Grid.new([
          "AB"
        ])
        expect(grid.at(Day04::GridCell.new(1, 0))).to eq [nil]
        expect(grid.at(Day04::GridCell.new(0, 2))).to eq [nil]
        expect(grid.at(Day04::GridCell.new(-1, 0))).to eq [nil]
        expect(grid.at(Day04::GridCell.new(0, -1))).to eq [nil]
      end

      it "returns multiple values if given multiple GridCells" do
        grid = Day04::Grid.new([
          "AB",
          "CD"
        ])
        expect(grid.at(Day04::GridCell.new(0, 0), Day04::GridCell.new(1, 1))).to eq ["A", "D"]
      end
    end

    context "#where" do
      it "returns an array of GridCells that match the given value" do
        grid = Day04::Grid.new([
          "AB",
          "CB"
        ])
        expect(grid.where("A")).to eq [Day04::GridCell.new(0, 0)]
        expect(grid.where("B")).to eq [Day04::GridCell.new(0, 1), Day04::GridCell.new(1, 1)]
        expect(grid.where("C")).to eq [Day04::GridCell.new(1, 0)]
        expect(grid.where("D")).to eq []
      end

      it "returns an array of GridCells that match the given block" do
        grid = Day04::Grid.new([
          "AB",
          "CB"
        ])
        expect(grid.where { |cell| cell == "A" || cell == "B" }).to eq [Day04::GridCell.new(0, 0), Day04::GridCell.new(0, 1), Day04::GridCell.new(1, 1)]
      end
    end
  end

  describe "XMASPattern" do
    context "#candidates_for" do
      let(:pattern) { Day04::WordPattern.new("XMAS") }
      it "generates the correct candidates to the right" do
        cell = Day04::GridCell.new(0, 0)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(0, 0), #  X
          Day04::GridCell.new(0, 1), #  M
          Day04::GridCell.new(0, 2), #  A
          Day04::GridCell.new(0, 3) #  S
        ]
      end

      it "generates the correct candidates to the left" do
        cell = Day04::GridCell.new(0, 3)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(0, 3), #  X
          Day04::GridCell.new(0, 2), #  M
          Day04::GridCell.new(0, 1), #  A
          Day04::GridCell.new(0, 0) #  S
        ]
      end

      it "generates the correct candidates up" do
        cell = Day04::GridCell.new(3, 0)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(3, 0), #  X
          Day04::GridCell.new(2, 0), #  M
          Day04::GridCell.new(1, 0), #  A
          Day04::GridCell.new(0, 0) #  S
        ]
      end

      it "generates the correct candidates down" do
        cell = Day04::GridCell.new(0, 0)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(0, 0), #  X
          Day04::GridCell.new(1, 0), #  M
          Day04::GridCell.new(2, 0), #  A
          Day04::GridCell.new(3, 0) #  S
        ]
      end

      it "generates the correct candidates up-right" do
        cell = Day04::GridCell.new(3, 0)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(3, 0), #  X
          Day04::GridCell.new(2, 1), #  M
          Day04::GridCell.new(1, 2), #  A
          Day04::GridCell.new(0, 3) #  S
        ]
      end

      it "generates the correct candidates down-right" do
        cell = Day04::GridCell.new(0, 0)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(0, 0), #  X
          Day04::GridCell.new(1, 1), #  M
          Day04::GridCell.new(2, 2), #  A
          Day04::GridCell.new(3, 3) #  S
        ]
      end

      it "generates the correct candidates up-left" do
        cell = Day04::GridCell.new(3, 3)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(3, 3), #  X
          Day04::GridCell.new(2, 2), #  M
          Day04::GridCell.new(1, 1), #  A
          Day04::GridCell.new(0, 0) #  S
        ]
      end

      it "generates the correct candidates down-left" do
        cell = Day04::GridCell.new(0, 3)
        expect(pattern.candidates_for(cell)).to include [
          Day04::GridCell.new(0, 3), #  X
          Day04::GridCell.new(1, 2), #  M
          Day04::GridCell.new(2, 1), #  A
          Day04::GridCell.new(3, 0) #  S
        ]
      end
    end
  end

  describe "WordSearch" do
    it "can be initialized with a grid and a word" do
      grid = Day04::Grid.new([
        "AB",
        "DA",
        "CD"
      ])
      search = Day04::WordSearch.new(grid, Day04::WordPattern.new("AB"))
      expect(search).to be_a Day04::WordSearch
    end

    describe "#count" do
      it "returns the number of times the word appears in the grid" do
        grid = Day04::Grid.new([
          "BA",
          "CA",
          "AB"
        ])
        search = Day04::WordSearch.new(grid, Day04::WordPattern.new("AB"))
        expect(search.count).to eq 4
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/04.txt", chomp: true)
      expect(Day04.part_one(input)).to eq 18
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/04.txt", chomp: true)
      expect(Day04.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
