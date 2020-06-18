require "rails_helper"
require "spec_helper"

RSpec.describe Favorite, type: :model do
  describe "#association" do
    it {should belong_to(:user)}
    it {should belong_to(:document)}
  end

  describe "#scopes" do
    let!(:history1){FactoryBot.create(:history, created_at: Time.now.prev_month(1))}
    let!(:history2){FactoryBot.create(:history, created_at: Time.now.prev_year(1))}
    let!(:history3){FactoryBot.create(:history)}
    context "find in month" do
      it "should be valid" do
        expect(History.find_in_month).to eq [history3]
      end
    end

    context "find in year" do
      it "should be valid" do
        expect(History.find_in_year).to eq [history1, history3]
      end
    end
  end
end
