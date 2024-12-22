require "./05"
RSpec.describe Day05 do
  context "part 1" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/05.txt", chomp: true)
      expect(Day05.part_one(input)).to eq 0 # TODO: replace with correct answer
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/05.txt", chomp: true)
      expect(Day05.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
