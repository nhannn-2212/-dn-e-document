require "spec_helper"
require "rails_helper"

RSpec.describe User, type: :model do

  describe "#association" do
    it {should respond_to(:documents)}
    it {should respond_to(:comments)}
    it {should respond_to(:favorites)}
    it {should respond_to(:histories)}
    it {should respond_to(:fav_docs)}
    it {should respond_to(:categories)}
  end

  describe "#password" do
    it {should have_secure_password}
  end

  describe "#scopes" do
    let!(:user1){FactoryBot.create(:user, fullname: "CCCCCCCCC", created_at: Time.now.prev_month(1))}
    let!(:user2){FactoryBot.create(:user, fullname: "BBBBBBBBB")}
    let!(:user3){FactoryBot.create(:user, fullname: "AAAAAAAAA")}
    context "sort by name ascending" do
      it "should be valid" do
        expect(User.sort_by_name).to eq [user3, user2, user1]
      end
    end

    context "find in month" do
      it "should be valid" do
        expect(User.find_in_month).to eq [user2, user3]
      end
    end
  end

  describe "#validations" do
    let!(:user) {FactoryBot.create :user}
    it {should validate_uniqueness_of(:email).ignoring_case_sensitivity}
    it {should validate_presence_of(:email)}
    it {should validate_presence_of(:fullname)}
    it {should validate_presence_of(:password)}
    it {should validate_length_of(:password)}

    context "email format" do
      it {should_not allow_value("test").for(:email)}
      it {should allow_value("test@abc.com").for(:email)}
    end
  end
end
