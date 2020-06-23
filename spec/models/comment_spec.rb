require "rails_helper"
require "spec_helper"

RSpec.describe Comment, type: :model do

  describe "#association" do
    it {should belong_to(:user)}
    it {should belong_to(:document)}
    it {should have_many(:reply_comments)}
    it {should belong_to(:comment).optional}
  end

  describe "#scopes" do
    let!(:comment1){FactoryBot.create(:comment)}
    let!(:comment2){FactoryBot.create(:comment, reply_comment_id: comment1.id)}
    let!(:comment3){FactoryBot.create(:comment)}
    context "sort by created at desc" do
      it "should be valid" do
        expect(Comment.by_created_at).to eq [comment3, comment2, comment1]
      end
    end

    context "find by root comment" do
      it "should be valid" do
        expect(Comment.root_comment).to eq [comment1, comment3]
      end
    end
  end

  describe "#validation" do
    let!(:comment){FactoryBot.create(:comment)}
    it {should validate_presence_of(:content)}
    it {should validate_length_of(:content).is_at_most(Settings.comment_max_length)}
  end
end
