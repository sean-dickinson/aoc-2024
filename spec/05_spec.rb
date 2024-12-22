require "./05"
RSpec.describe Day05 do
  describe "Rule" do
    it "is created from a string" do
      rule = Day05::Rule.new("53|13")
      expect(rule).to be_a(Day05::Rule)
    end

    describe "#valid?" do
      it "is true if none of the update page numbers apply" do
        rule = Day05::Rule.new("53|13")
        update = Day05::Update.new("1,2,3")
        expect(rule.valid?(update)).to eq true
      end

      it "is true if the page numbers are in the correct order" do
        rule = Day05::Rule.new("53|13")
        update = Day05::Update.new("53,13,1")
        expect(rule.valid?(update)).to eq true
      end

      it "is true when the page numbers are in the correct order even if other numbers are in between them" do
        rule = Day05::Rule.new("53|13")
        update = Day05::Update.new("53,1,13")
        expect(rule.valid?(update)).to eq true
      end

      it "is false if the page numbers are in the wrong order" do
        rule = Day05::Rule.new("53|13")
        update = Day05::Update.new("13,53,1")
        expect(rule.valid?(update)).to eq false
      end
    end
  end

  describe "Update" do
    it "is created from a string" do
      update = Day05::Update.new("75,47,61,53,29")
      expect(update).to be_a(Day05::Update)
    end

    it "responds to middle with the middle number" do
      update = Day05::Update.new("75,47,61,53,29")
      expect(update.middle).to eq 61
    end
  end

  describe "Validator" do
    it "is created from an array of rules and an array of updates" do
      rules = [
        Day05::Rule.new("75|47"),
        Day05::Rule.new("75|61"),
        Day05::Rule.new("75|53"),
        Day05::Rule.new("75|29")
      ]
      updates = [
        Day05::Update.new("75,47,61,53,29")
      ]
      validator = Day05::Validator.new(rules, updates)
      expect(validator).to be_a(Day05::Validator)
    end

    describe "#valid_updates" do
      it "returns an array of updates that are valid" do
        rules = [
          Day05::Rule.new("75|47"),
          Day05::Rule.new("75|61"),
          Day05::Rule.new("75|53"),
          Day05::Rule.new("75|29"),
          Day05::Rule.new("97|75") # makes 2nd update invalid
        ]
        updates = [
          Day05::Update.new("75,47,61,53,29"),
          Day05::Update.new("75,97,47,61,53")

        ]
        validator = Day05::Validator.new(rules, updates)

        valid_updates = validator.valid_updates
        expect(valid_updates.size).to eq 1
        expect(valid_updates.first.pages).to eq [75, 47, 61, 53, 29]
      end
    end

    describe "self.from_input" do
      it "creates a validator from an array of strings" do
        input = [
          "75|47",
          "75|61",
          "75|53",
          "75|29",
          "97|75",
          "",
          "75,47,61,53,29",
          "75,97,47,61,53"
        ]
        validator = Day05::Validator.from_input(input)
        expect(validator).to be_a(Day05::Validator)
      end

      it "can correctly parse the input file" do
        input = File.readlines("spec/test_inputs/05.txt", chomp: true)
        validator = Day05::Validator.from_input(input)
        expect(validator.rules.size).to eq 21
        expect(validator.updates.size).to eq 6
      end
    end
  end

  context "part 1" do
    it "returns the correct answer for the example input" do
      input = File.readlines("spec/test_inputs/05.txt", chomp: true)
      expect(Day05.part_one(input)).to eq 143
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
