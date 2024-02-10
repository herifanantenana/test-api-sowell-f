require 'rails_helper'

RSpec.describe Export, type: :model do
  let(:export) { create(:export) }
  describe "#default export" do
    it "is valid" do
      expect(export).to be_valid
    end
  end

  describe "#url" do
    it "cant be define when status is not done" do
      expect do
        export.url = Faker::Internet.url
        export.save!
      end
    end

  end


end
