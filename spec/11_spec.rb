require "./11"
RSpec.describe Day11 do
  describe Day11::Stone do
    it "has a number" do
      stone = Day11::Stone.new(1)
      expect(stone.number).to eq 1
    end

    context "#blink" do
      it "is replaced by a stone with number 1 if it has a number 0" do
        stone = Day11::Stone.new(0)
        expect(stone.blink).to eq Day11::Stone.new(1)
      end

      context "even digits" do
        it "becomes 2 stones with the digits split between them" do
          stone = Day11::Stone.new(12)
          expect(stone.blink).to eq [Day11::Stone.new(1), Day11::Stone.new(2)]
        end

        it "ignores leading zeros" do
          stone = Day11::Stone.new(1000)
          expect(stone.blink).to eq [Day11::Stone.new(10), Day11::Stone.new(0)]
        end
      end

      it "is replaced by a stone with its number multiplied by 2024 if neither rule applies" do
        stone = Day11::Stone.new(3)
        expect(stone.blink).to eq Day11::Stone.new(3 * 2024)
      end
    end
  end

  describe Day11::StoneFactory do
    it "parses a list of stones from an string" do
      stone_factory = Day11::StoneFactory.new("0 1 10 99 999")
      stones = stone_factory.create!
      expect(stones).to eq [
                             Day11::Stone.new(0),
                             Day11::Stone.new(1),
                             Day11::Stone.new(10),
                             Day11::Stone.new(99),
                             Day11::Stone.new(999)
                           ]
    end
  end

  context "examples" do
    it "returns the correct answer for the first blink" do
      stones = [Day11::Stone.new(125), Day11::Stone.new(17)]
      expect(stones.flat_map(&:blink)).to eq [
                                               Day11::Stone.new(253000),
                                               Day11::Stone.new(1),
                                               Day11::Stone.new(7)
                                             ]
    end

    it "returns the correct answer for the second blink" do
      stones = [
        Day11::Stone.new(253000),
        Day11::Stone.new(1),
        Day11::Stone.new(7)
      ]

      expect(stones.flat_map(&:blink)).to eq [
                                               Day11::Stone.new(253),
                                               Day11::Stone.new(0),
                                               Day11::Stone.new(2024),
                                               Day11::Stone.new(14168)
                                             ]
    end

    it "returns the correct answer for the 3rd blink" do
      stones = [
        Day11::Stone.new(253),
        Day11::Stone.new(0),
        Day11::Stone.new(2024),
        Day11::Stone.new(14168)
      ]

      expect(stones.flat_map(&:blink)).to eq [
                                                Day11::Stone.new(512072),
                                                Day11::Stone.new(1),
                                                Day11::Stone.new(20),
                                                Day11::Stone.new(24),
                                                Day11::Stone.new(28676032)
                                             ]
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/11.txt", chomp: true)
      expect(Day11.part_one(input)).to eq 55312
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/11.txt", chomp: true)
      expect(Day11.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
