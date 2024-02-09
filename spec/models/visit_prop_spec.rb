require 'rails_helper'

RSpec.describe VisitProp, type: :model do
  let(:company) { create(:company) }
  let(:base_location_type) { create(:base_location_type, depth_level: 2) }
  let(:location_type) { create(:location_type, base_location_type: base_location_type, company: company) }
  let(:checklist) { create(:checklist, location_type: location_type, company: company) }
  let(:residence) { create(:residence, company: company) }
  let(:place) { create(:place, residence: residence, company: company) }
  let(:spot) { create(:spot) }
  let(:base_issue_type) { create(:base_issue_type, base_location_type: base_location_type) }
  let(:issue_type) { create(:issue_type, location_type: location_type, base_issue_type: base_issue_type, company: company) }
  let(:checkpoint) { create(:checkpoint, checklist: checklist, issue_type: issue_type) }
  let(:visit_prop) { create(:visit_prop, checkpoint: checkpoint, place: place, residence: nil, spot: nil) }

  describe '#default visit_prop' do
    it 'is valid' do
      expect(visit_prop).to be_valid
    end

    it "should have only on of residence, spot or place" do
      expect do
        visit_prop.update(residence: residence, place: place, spot: spot)
        visit_prop.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_prop.update(residence: nil, place: place, spot: spot)
        visit_prop.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_prop.update(residence: nil, place: nil, spot: nil)
        visit_prop.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#the depth level of base location type relative to the checkpoint" do
    [
      { depth_level: 1, symbol_location: :residence },
      { depth_level: 2, symbol_location: :place },
      { depth_level: 3, symbol_location: :spot }
    ].each do |correspondence|
      it "should correspond to #{correspondence[:symbol_location]}" do
        base_location_type.update(depth_level: correspondence[:depth_level])
        visit_prop.update(residence: residence, place: nil, spot: nil) if correspondence[:symbol_location] == :residence
        visit_prop.update(residence: nil, place: place, spot: nil) if correspondence[:symbol_location] == :place
        visit_prop.update(residence: nil, place: nil, spot: spot) if correspondence[:symbol_location] == :spot
        visit_prop.save!
        expect(checkpoint&.checklist&.location_type&.base_location_type.depth_level.downcase).to eq(visit_prop.send(correspondence[:symbol_location]).class.name.downcase)
      end
    end
  end
end
