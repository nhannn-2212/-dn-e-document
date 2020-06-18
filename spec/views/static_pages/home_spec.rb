require "rails_helper"
require "spec_helper"
include SessionsHelper

RSpec.describe "static_pages/home", type: :view do
  before do
    @user = FactoryBot.create(:user)
    log_in @user
    @document = Document.new
    @documents = FactoryBot.create_list(:document, 10, :approved_doc)
    @user.fav_docs << @documents[0]
    allow(view).to receive_messages(:will_paginate => nil)
  end

  context "render template" do
    it "display list document" do
      render
      view.should render_template(partial: "_list")
    end

    it "display li document" do
      render
      view.should render_template(partial: "_document", count: 10)
    end

    it "display doc form" do
      render
      view.should render_template(partial: "_doc_form")
    end

    it "display error partial" do
      render
      view.should render_template(partial: "_error_messages")
    end

    it "display favorite partial" do
      render
      view.should render_template(partial: "_favorite", count: 9)
    end

    it "display favorite partial" do
      render
      view.should render_template(partial: "_unfavorite", count: 1)
    end

    it "display favorite form" do
      render
      view.should render_template(partial: "_favorite_form")
    end
  end

  context "display element" do
    it "display create category" do
      render
      expect(rendered).to have_selector("a", text: I18n.t("create_category"))
    end
  end
end
