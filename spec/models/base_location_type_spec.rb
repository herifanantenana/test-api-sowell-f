require 'rails_helper'

RSpec.describe BaseLocationType, type: :model do
  let(:base_location_type) { create(:base_location_type) }
  describe "#default base_location_type" do
    it "is valid" do
      expect(base_location_type).to be_valid
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        base_location_type.name = nil
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        base_location_type.name = ""
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#depth_level" do
    it "is not empty" do
      expect do
        base_location_type.depth_level = nil
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "have a valide value of the enumerable" do
      expect do
        base_location_type.depth_level = nil
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      base_location_type.depth_level = rand(1..3)
      base_location_type.save!
      expect(base_location_type.depth_level).to eq("residence").or eq("place").or eq("spot")
      expect(base_location_type).to be_valid
    end
  end
end
