require "rails_helper"
require "spec_helper"

RSpec.describe Document, type: :model do

  describe "#association" do
    it {should belong_to(:user)}
    it {should belong_to(:category)}
    it {should respond_to(:doc)}
    it {should have_many(:comments)}
    it {should have_many(:histories)}
    it {should have_many(:favorites)}
    it {should have_many(:fav_users)}
    it {should accept_nested_attributes_for(:category)}
  end

  describe "#delegate" do
    it {should delegate_method(:fullname).to(:user).with_prefix(true).allow_nil}
    it {should delegate_method(:size).to(:histories).with_prefix(true)}
    it {should delegate_method(:content_type).to(:doc)}
    it {should delegate_method(:previewable?).to(:doc)}
    it {should delegate_method(:preview).to(:doc)}
  end

  describe "#scopes" do
    let!(:document1){FactoryBot.create(:document, name: "Doc2", created_at: Time.now.prev_month(1))}
    let!(:document2){FactoryBot.create(:document, name: "Doc3")}
    let!(:document3){FactoryBot.create(:document, name: "Doc1", created_at: Time.now.prev_year(2))}
    context "sort by created_at desc" do
      it "should be valid" do
        expect(Document.sort_by_created_at).to eq [document2, document1, document3]
      end
    end

    context "sort by name asc" do
      it "should be valid" do
        expect(Document.sort_by_name).to eq [document3, document1, document2]
      end
    end

    context "find in month" do
      it "should be valid" do
        expect(Document.find_in_month).to eq [document2]
      end
    end

    context "find in year" do
      it "should be valid" do
        expect(Document.find_in_year.sort_by_created_at).to eq [document2, document1]
      end
    end

    context "search" do
      it "should be valid" do
        expect(Document.search("doc1")).to eq [document3]
      end
    end
  end

  describe "#validations" do
    let!(:document) {FactoryBot.create(:document)}
    it {should validate_presence_of(:name)}
    it {should validate_length_of(:name).is_at_least(Settings.doc_min_length).is_at_most(Settings.doc_max_length)}
    it {should validate_presence_of(:doc)}
  end

  describe "#reject_category" do
    let!(:document){FactoryBot.create(:document)}
    let!(:category_attributes_invalid){FactoryBot.attributes_for(:document, category_attributes: {name: nil})}
    let!(:category_attributes_valid){FactoryBot.attributes_for(:document, category_attributes: {name: "abc"})}
    it "should be reject" do
      expect(document.reject_category(category_attributes_invalid[:category_attributes])).to eq true
    end

    it "should be accept" do
      expect(document.reject_category(category_attributes_valid[:category_attributes])).to eq false
    end
  end
end
