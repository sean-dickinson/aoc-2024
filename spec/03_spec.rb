require "./03"
RSpec.describe Day03 do
  describe "Multiplier" do
    it "multiplies the 2 numbers" do
      expect(Day03::Multiplier.new(2, 3).result).to eq 6
    end
  end

  describe "MultiplierParser" do
    it "creates a list of Multipliers from valid input" do
      input = "xmul(44,46)+mul(32,64]"
      expect(Day03::MultiplierParser.new(input).parse).to eq [Day03::Multiplier.new(44, 46)]
    end

    it "rejects input with spaces" do
      input = "mul ( 2, 4 )"
      expect(Day03::MultiplierParser.new(input).parse).to eq []
    end

    it "rejects inputs with numbers that are more than 3 digits" do
      input = "mul(1000, 4)"
      expect(Day03::MultiplierParser.new(input).parse).to eq []
    end
    it "rejects inputs with other symbols" do
      input = "mul(2,4!)mul(4*_?(12,34)"
      expect(Day03::MultiplierParser.new(input).parse).to eq []
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/03.txt", chomp: true)
      expect(Day03.part_one(input)).to eq 161
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/03.txt", chomp: true)
      expect(Day03.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
