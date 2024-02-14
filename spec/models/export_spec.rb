require 'rails_helper'

RSpec.describe Export, type: :model do
  let(:params) { create(:company)}
  let(:export) { create(:export, name: "test company", params: params) }
  describe "#default export" do
    it "is valid" do
      expect(export).to be_valid
    end
  end

  describe "#url" do
    it "cant be define when status is not done" do
      expect do
        export.status = 0
        export.url = Faker::Internet.url
        export.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  describe "#name" do
    it "should correspond to data model in params" do
      expect do
        company = create(:company)
        create(:export, name: "test companyss", params: company)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

  end


end
