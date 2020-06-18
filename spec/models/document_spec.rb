require "rails_helper"
require "spec_helper"

RSpec.describe Category, type: :model do

  describe "#association" do
    it {should belong_to(:user)}
    it {should belong_to(:category)}
    it {should have_many(:comments)}
    it {should have_many(:favorites)}
    it {should have_many(:fav_users)}
    it {should have_many(:histories)}
    it {should have_one(:doc)}
    it {should accept_nested_attributes_for :category}
  end

  describe "#delegate" do
    it {should delegate_method(:fullname).to(:user).with_prefix(true)}
  end

  describe "#scopes" do
    let!(:category1){FactoryBot.create(:document)}
    let!(:category2){FactoryBot.create(:category)}
    let!(:category3){FactoryBot.create(:category)}
    context "sort by created at desc" do
      it "should be valid" do
        expect(Category.sort_by_name).to eq [category2, category1, category3]
      end
    end
  end

  describe "#validations" do
    let!(:category) {FactoryBot.create(:category)}
    it {should validate_uniqueness_of(:name)}
    it {should validate_presence_of(:name)}
    it {should validate_length_of(:name).is_at_least(Settings.category_min_length).is_at_most(Settings.category_max_length)}
  end
end
