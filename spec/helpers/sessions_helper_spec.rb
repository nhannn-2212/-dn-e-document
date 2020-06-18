require "rails_helper"
require "spec_helper"
include SessionsHelper

RSpec.describe SessionsHelper, type: :helper do
  before do
    @user = FactoryBot.create(:user)
    log_in @user
  end
  describe ".log_in" do
    it "log in" do
      expect(session[:user_id]).to eq @user.id
    end
  end

  describe ".current_user?" do
    it "current user?" do
      expect(current_user?(@user)).to eq true
    end
  end

  describe ".current user" do
    it "return current user" do
      expect(current_user).to eq @user
    end
  end

  describe ".logged_in?" do
    it "true if logged in" do
      expect(logged_in?).to eq true
    end

    it "false if not log in" do
      log_out
      expect(logged_in?).to eq false
    end
  end

  describe ".log_out" do
    it "log out" do
      log_out
      expect(current_user).to eq nil
    end
  end
end
