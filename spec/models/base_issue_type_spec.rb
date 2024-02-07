require 'rails_helper'

RSpec.describe BaseIssueType, type: :model do
  let(:base_issue_type) { create(:base_issue_type) }

  describe "#default base_issue_type" do
    it "is valid" do
      expect(base_issue_type).to be_valid
    end
  end

  describe "#name" do
    it "is not empty" do
      expect do
        base_issue_type.name = nil
        expect(base_issue_type).not_to be_valid
        base_issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        base_issue_type.name = ""
        expect(base_issue_type).not_to be_valid
        base_issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#base_location_type" do
    it "is not empty" do
      expect do
        base_issue_type.base_location_type = nil
        expect(base_issue_type).not_to be_valid
        base_issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
