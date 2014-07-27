include ActiveModel::Lint::Tests

describe Tableless do
  describe "#initialize" do
    before do
      class Person < Tableless
        attr_accessor :name
      end
    end

    it "takes an array of attributes and sets them" do
      person = Person.new(name: "Sam")
      expect(person.name).to eq("Sam")
    end

    it "does not set undefined attributes" do
      person = Person.new(name: "Sam", title: "Prof")
      expect { person.title }.to raise_error(NoMethodError)
    end
  end

  describe "#new_record?" do
    it "should return true for a new object" do
      tableless = Tableless.new
      expect(tableless.new_record?).to eq(true)
    end

    it "should return false for an object with attributes set" do
      tableless = Tableless.new(name: "Sam")
      expect(tableless.new_record?).to eq(false)
    end
  end

  describe "#persisted?" do
    it "should not be persisted" do
      tableless = Tableless.new
      expect(tableless.persisted?).to be false
    end
  end
end
