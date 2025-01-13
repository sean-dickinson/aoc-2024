require "./09"
RSpec.describe Day09 do
  describe Day09::Block do
    it "can be empty" do
      block = Day09::Block.new(nil)
      expect(block).to be_a(Day09::Block)
      expect(block.file_id).to be_nil
      expect(block).to be_empty
    end

    it "can have a file_id" do
      block = Day09::Block.new(2)
      expect(block).to be_a(Day09::Block)
      expect(block.file_id).to eq 2
    end
  end

  describe Day09::DiskMapFactory do
    it "creates a diskmap from a string" do
      factory = Day09::DiskMapFactory.new("111")
      map = factory.parse
      expect(map).to be_a(Day09::DiskMap)
      expect(map.blocks).to contain_exactly(
        Day09::Block.new(0),
        Day09::Block.new(nil),
        Day09::Block.new(1)
      )
    end

    it "creates the correct diskmap from 12345" do
      expected_blocks = [
        Day09::Block.new(0),
        Day09::Block.new(nil),
        Day09::Block.new(nil),
        Day09::Block.new(1),
        Day09::Block.new(1),
        Day09::Block.new(1),
        Day09::Block.new(nil),
        Day09::Block.new(nil),
        Day09::Block.new(nil),
        Day09::Block.new(nil),
        Day09::Block.new(2),
        Day09::Block.new(2),
        Day09::Block.new(2),
        Day09::Block.new(2),
        Day09::Block.new(2)
      ]

      factory = Day09::DiskMapFactory.new("12345")
      map = factory.parse

      expect(map).to be_a(Day09::DiskMap)
      expect(map.blocks).to contain_exactly(*expected_blocks)
    end
  end

  describe Day09::DiskMap do
    it "responds to #to_s" do
      factory = Day09::DiskMapFactory.new("12345")
      map = factory.parse

      expect(map.to_s).to eq "0..111....22222"
    end

    describe "compact!" do
      it "correctly rearranges blocks for the 12345 example" do
        factory = Day09::DiskMapFactory.new("12345")
        map = factory.parse

        map.compact!

        expect(map.to_s).to eq "022111222......"
      end
    end

    it "calculates the checksum by summing the blocks position times their file id" do
      factory = Day09::DiskMapFactory.new("12345")

      map = factory.parse
      map.compact!

      # 022111222......
      expect(map.checksum).to eq (0 * 0) + (1 * 2) + (2 * 2) + (3 * 1) + (4 * 1) + (5 * 1) + (6 * 2) + (7 * 2) + (8 * 2)
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/09.txt", chomp: true)
      expect(Day09.part_one(input)).to eq 1928
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/09.txt", chomp: true)
      expect(Day09.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
