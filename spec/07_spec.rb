require "./07"
RSpec.describe Day07 do
  describe "Integer" do
    it "can be concatenated with another integer" do
      expect(1 | 2).to eq 12
    end
  end
  describe "Equation" do
    context "self.from_string" do
      it "can be created from a string" do
        input = "190: 10 19"
        equation = Day07::Equation.from_string(input)
        expect(equation).to be_a Day07::Equation
        expect(equation.solution).to eq 190
        expect(equation.terms).to eq [10, 19]
      end
    end
    it "has a solution an terms" do
      equation = Day07::Equation.new(solution: 37, terms: [5, 6, 7])
      expect(equation.solution).to eq 37
      expect(equation.terms).to eq [5, 6, 7]
    end

    context "valid?" do
      it "is valid? if the solution is the sum of the terms" do
        equation = Day07::Equation.new(solution: 11, terms: [5, 6])
        expect(equation).to be_valid
      end

      it "is valid? if the solution is the product of the terms" do
        equation = Day07::Equation.new(solution: 30, terms: [5, 6])
        expect(equation).to be_valid
      end

      it "is valid if the solution is the sum of the first 2 terms times the last term" do
        equation = Day07::Equation.new(solution: 77, terms: [5, 6, 7])
        expect(equation).to be_valid
      end

      it "is valid if the solution is the product of the first 2 terms plus the last term" do
        equation = Day07::Equation.new(solution: 37, terms: [5, 6, 7])
        expect(equation).to be_valid
      end

      it "is valid for more than 3 terms" do
        equation = Day07::Equation.new(solution: 292, terms: [11, 6, 16, 20]) # 11 + 6 * 16 + 20
        expect(equation).to be_valid
      end

      it "is not valid if the solution is not the sum or product of the terms" do
        equation = Day07::Equation.new(solution: 38, terms: [5, 6, 7])
        expect(equation).not_to be_valid
      end

      context "concatenation" do
        it "is valid if the solution is the concatenation of the terms" do
          equation = Day07::Equation.new(solution: 56, terms: [5, 6], additional_operators: [:|])
          expect(equation).to be_valid
        end

        it "is valid if the concatenation can be applied with in addition to multiplication to make it true" do
          equation = Day07::Equation.new(solution: 7290, terms: [6, 8, 6, 15], additional_operators: [:|])
          # 6 * 8 | 6 * 15
          expect(equation).to be_valid
        end
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/07.txt", chomp: true)
      expect(Day07.part_one(input)).to eq 3749
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/07.txt", chomp: true)
      expect(Day07.part_two(input)).to eq 11387
    end
  end
end
