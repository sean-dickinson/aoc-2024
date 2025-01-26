require "./11"
RSpec.describe Day11 do
  describe Day11::StoneCollection do
    describe "#size" do
      it "returns the number of stones" do
        stones = Day11::StoneCollection.new([1, 2, 3])
        expect(stones.size).to eq 3
      end
    end

    describe "#+" do
      it "can be added to another stone collection" do
        stones = Day11::StoneCollection.new([1, 2, 3])
        other_stones = Day11::StoneCollection.new([4, 5])
        expect(stones + other_stones).to eq Day11::StoneCollection.new([1, 2, 3, 4, 5])
      end
    end

    describe "#blink" do
      context "single stone" do
        it "is returns by a stone with number 1 if it has a number 0" do
          stone = Day11::StoneCollection.new([0])
          expect(stone.blink).to eq Day11::StoneCollection.new([1])
        end

        context "even digits" do
          it "becomes 2 stones with the digits split between them" do
            stone = Day11::StoneCollection.new([12])
            expect(stone.blink).to eq Day11::StoneCollection.new([1, 2])
          end

          it "ignores leading zeros" do
            stone = Day11::StoneCollection.new([1000])
            expect(stone.blink).to eq Day11::StoneCollection.new([10, 0])
          end
        end

        it "is replaced by a stone with its number multiplied by 2024 if neither rule applies" do
          stone = Day11::StoneCollection.new([3])
          expect(stone.blink).to eq Day11::StoneCollection.new([3 * 2024])
        end
      end

      context "multiple stones" do
        it "blinks each stone" do
          stones = Day11::StoneCollection.new([1, 2])
          expect(stones.blink).to eq Day11::StoneCollection.new([1]).blink + Day11::StoneCollection.new([2]).blink
        end
      end
    end
  end

  describe Day11::StoneFactory do
    it "parses a list of stones from an string" do
      stone_factory = Day11::StoneFactory.new("0 1 10 99 999")
      stones = stone_factory.create!
      expect(stones).to eq Day11::StoneCollection.new([0, 1, 10, 99, 999])
    end
  end

  context "examples" do
    it "returns the correct answer for the first blink" do
      stones = Day11::StoneCollection.new([125, 17])
      expect(stones.blink).to eq Day11::StoneCollection.new([253000, 1, 7])
    end

    it "returns the correct answer for the second blink" do
      stones = Day11::StoneCollection.new([253000, 1, 7])

      expect(stones.blink).to eq Day11::StoneCollection.new([253, 0, 2024, 14168])
    end

    it "returns the correct answer for the 3rd blink" do
      stones = Day11::StoneCollection.new([253, 0, 2024, 14168])

      expect(stones.blink).to eq Day11::StoneCollection.new([512072, 1, 20, 24, 28676032])
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
