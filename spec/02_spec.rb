require "./02"
RSpec.describe Day02 do
  describe "Report" do
    context "#self.from_string" do
      it "creates a report from a string" do
        report = Day02::Report.from_string("1 2 3 4 5")
        expect(report).to be_a Day02::Report
        expect(report.levels).to eq [1, 2, 3, 4, 5]
      end
    end

    context "#safe?" do
      it "is safe when all levels are all decreasing by 1 or 2" do
        expect(Day02::Report.new(7, 6, 4, 2, 1)).to be_safe
      end

      it "is safe when all levels are all increasing by 1 or 2" do
        expect(Day02::Report.new(1, 3, 6, 7, 9)).to be_safe
      end

      it "is not safe when any level is increasing by more than 1 or 2" do
        expect(Day02::Report.new(1, 2, 7, 8, 9)).not_to be_safe
      end

      it "is not safe when any level is decreasing by more than 2" do
        expect(Day02::Report.new(9, 7, 6, 2, 1)).not_to be_safe
      end

      it "is not safe when the levels are not all increasing or decreasing" do
        expect(Day02::Report.new(1, 3, 2, 4, 5)).not_to be_safe
      end

      it "is not safe when there is no change between some of the levels" do
        expect(Day02::Report.new(8, 6, 4, 4, 1)).not_to be_safe
      end
    end
  end
  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/02.txt", chomp: true)
      expect(Day02.part_one(input)).to eq 2
    end
  end

  context "part 2" do
    it "returns the correct answer for the example input" do
      pending
      input = File.readlines("spec/test_inputs/02.txt", chomp: true)
      expect(Day02.part_two(input)).to eq 0 # TODO: replace with correct answer
    end
  end
end
