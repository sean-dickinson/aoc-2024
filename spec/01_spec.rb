require "./01"
RSpec.describe Day01 do

  context "LocationPair" do
    it "calculates the distance between two locations" do
      expectations = {
        [1, 3] => 2,
        [2, 3] => 1,
        [3, 3] => 0,
        [3, 4] => 1,
        [3, 5] => 2,
        [4, 9] => 5,
        [9,4] => 5,
      }
      expectations.each do |pair, result|
        expect(Day01::LocationPair.new(*pair).distance).to eq result
      end
    end

    it "can be compared to another LocationPair" do
      pair1 = Day01::LocationPair.new(1, 2)
      pair2 = Day01::LocationPair.new(1, 2)
      pair3 = Day01::LocationPair.new(2, 3)
      expect(pair1).to eq pair2
      expect(pair1).not_to eq pair3
    end
  end

  context "LocationPairList" do
    it "calculates the total distance between two lists of locations" do
      left_list = [1,2,3]
      right_list = [3,3,3]
      expect(Day01::LocationPairList.new(left_list, right_list).total_distance).to eq 2 + 1 + 0
    end

    it "can be compared to another LocationPairList" do
      left_list = [1,2,3]
      right_list = [3,3,3]
      list1 = Day01::LocationPairList.new(left_list, right_list)
      list2 = Day01::LocationPairList.new(left_list, right_list)
      list3 = Day01::LocationPairList.new([1,2,3], [3,3,4])
      expect(list1).to eq list2
      expect(list1).not_to eq list3
    end

    describe "#self.from_input" do
      it "creates a LocationPairList from the raw input" do
        input = ["3   4", "2   5"]
        expected_left_list = [2, 3]
        expected_right_list = [4, 5]
        list = Day01::LocationPairList.from_input(input)
        expect(list).to be_a Day01::LocationPairList
        expected_list = Day01::LocationPairList.new(expected_left_list, expected_right_list)
        expect(list).to eq expected_list
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/01.txt", chomp: true)
      expect(Day01.part_one(input)).to eq 11
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/01.txt", chomp: true)
      expect(Day01.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
