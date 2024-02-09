require "rails_helper"

RSpec.describe VisitSchedule, type: :model do
  let(:company) { create(:company) }

  let!(:visit_schedule) { create(:visit_schedule) }

  let(:other_company) { create(:company) }
  let(:other_checklist) { create(:checklist, company: other_company) }
  let(:other_place) { create(:place, company: other_company) }
  let!(:other_visit_schedule) { create(:visit_schedule, checklist: other_checklist) }

  describe "#default visit_schedule" do
    it "is valid" do
      expect(visit_schedule).to be_valid
    end
  end

  describe "#place" do
    it "is not empty" do
      expect do
        visit_schedule.place_id = nil
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the place" do
      expect do
        visit_schedule.place = other_place
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#checklist" do
    it "is not empty" do
      expect do
        visit_schedule.checklist_id = nil
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the checklist" do
      expect do
        visit_schedule.checklist = other_checklist
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#due_at" do
    it "is not empty if checklist is planned" do
      expect do
        visit_schedule.due_at = nil
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_schedule.due_at = ""
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "is empty if checklist is not planned" do
      expect do
        visit_schedule.due_at = nil
        visit_schedule.checklist.is_planned = false
        visit_schedule.save!
      end

      expect do
        visit_schedule.due_at = ""
        visit_schedule.checklist.is_planned = false
        visit_schedule.save!
      end
    end

    it "is invalid with due_date < now" do
      expect do
        visit_schedule.due_at = DateTime.now - 1.days
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid with due_at if checklist is unplanned" do
      expect do
        visit_schedule.checklist.update(is_planned: false)
        visit_schedule.due_at = Date.today + 15.day
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "change due_at when Visiteport is created and checklist is planned" do
      visit_report = create(:visit_report, visit_schedule: visit_schedule)
      due_at_expected = visit_report.created_at + visit_schedule.checklist.recurrence
      assert_equal due_at_expected.to_date, visit_schedule.due_at
    end

    it "change due_at when Visiteport is created and checklist is planned" do
      checklist_unplanned = create(:checklist, recurrence: nil, is_planned: false)
      visit_schedule_unplanned = create(:visit_schedule, checklist: checklist_unplanned, due_at: nil)
      visit_report = create(:visit_report, visit_schedule: visit_schedule_unplanned)

      assert_nil visit_schedule_unplanned.due_at
    end
  end

  # i commented one line n11 because it was causing an error when running the test
  let(:base_location_type) { create(:base_location_type, depth_level: 1) }
  let(:location_type) { create(:location_type, base_location_type: base_location_type, company: company) }
  let(:checklist) { create(:checklist, location_type: location_type, company: company) }
  let(:residence) { create(:residence, company: company) }
  let(:place) { create(:place, residence: residence, company: company) }
  let(:spot) { create(:spot) }
  let(:visit_schedule) {create(:visit_schedule, checklist: checklist, place: nil, residence: residence, spot: nil)}

  describe "#defaut second test visit_schedule" do
    it "is valid" do
      expect(visit_schedule).to be_valid
    end

    it "should have only on of residence, spot or place" do
      expect do
        visit_schedule.update(residence: residence, place: place, spot: spot)
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_schedule.update(residence: nil, place: place, spot: spot)
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        visit_schedule.update(residence: nil, place: nil, spot: nil)
        visit_schedule.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  describe "#the depth level of base location type relative to the checklist" do
    [
      { depth_level: 1, symbol_location: :residence },
      { depth_level: 2, symbol_location: :place },
      { depth_level: 3, symbol_location: :spot }
    ].each do |correspondence|
      it "should correspond to #{correspondence[:symbol_location]}" do
        base_location_type.update(depth_level: correspondence[:depth_level])
        visit_schedule.update(residence: residence, place: nil, spot: nil) if correspondence[:symbol_location] == :residence
        visit_schedule.update(residence: nil, place: place, spot: nil) if correspondence[:symbol_location] == :place
        visit_schedule.update(residence: nil, place: nil, spot: spot) if correspondence[:symbol_location] == :spot
        visit_schedule.save!
        expect(checklist&.location_type&.base_location_type.depth_level.downcase).to eq(visit_schedule.send(correspondence[:symbol_location]).class.name.downcase)
      end
    end
  end

end
