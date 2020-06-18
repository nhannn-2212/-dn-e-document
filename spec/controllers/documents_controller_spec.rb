require "rails_helper"
require "spec_helper"
include SessionsHelper

RSpec.describe DocumentsController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:user, :admin)
    log_in @user
  end
  describe "GET #show" do
    let!(:document){FactoryBot.create(:document)}

    it "assign @document" do
      get :show, params: {id: document}
      expect(assigns(:document)).to eq(document)
    end

    it "render the #show view" do
      get :show, params: {id: document}
      expect(response).to render_template :show
    end

    it "flash error if doc invalid" do
      get :show, params: {id: "100"}
      expect(flash[:danger]).to eq(I18n.t "error.invalid_doc")
    end

    it {should route(:get, "documents/1").to(action: :show, id: 1)}
  end

  describe "POST #create" do
    let!(:category){FactoryBot.create(:category)}
    context "valid attributes" do
      it "create new document" do
        expect {
          post :create, params: {document: FactoryBot.attributes_for(:document, category_id: category.id, category_attributes: {name: nil})}
        }.to change(Document, :count).by(1)
      end

      it "add coin" do
        post :create, params: {document: FactoryBot.attributes_for(:document, category_id: category.id, category_attributes: {name: nil})}
        expect(current_user.coin).to eq(10)
      end

      it "create new doc with nested cate" do
        expect {
          post :create, params: {document: FactoryBot.attributes_for(:document, category_attributes: attributes_for(:category))}
        }.to change(Category, :count).by(1)
      end

      it "create cate and send email" do
        expect {
          post :create, params: {document: FactoryBot.attributes_for(:document, category_attributes: attributes_for(:category))}
        }.to change(ActionMailer::Base.deliveries, :length)
      end

      it "flash success" do
        post :create, params: {document: FactoryBot.attributes_for(:document, category_id: category.id, category_attributes: {name: nil})}
        expect(flash[:success]).to eq(I18n.t "success.doc_upload")
      end
    end

    context "invalid attributes" do
      it "don't create document" do
        expect{
          post :create, params: {document: FactoryBot.attributes_for(:document, category_attributes: {name: nil})}
        }.to_not change(Document, :count)
      end

      it "flash error" do
        post :create, params: {document: FactoryBot.attributes_for(:document, category_attributes: {name: nil})}
        expect(flash[:danger]).to eq(I18n.t "error.doc_upload")
      end
    end
  end

  describe "GET #search" do
    let!(:document){FactoryBot.create(:document, :approved_doc, name: "AAAAAAAAA")}
    let!(:document1){FactoryBot.create(:document, :approved_doc, name: "bbbbbbbb")}
    let!(:document2){FactoryBot.create(:document)}
    context "search with doc_name" do
      it "find doc by name" do
        get :search, xhr: true, params: {search: "bbbbb"}
        expect(assigns :documents).to eq [document1]
      end
    end

    context "search with cate_name" do
      it "find doc by cate" do
        get :search, xhr: true, params: {search: document.category.name}
        expect(assigns :documents). to eq [document]
      end
    end

    context "search all" do
      it "find all" do
        get :search, xhr: true, params: {search: ""}
        expect(assigns :documents).to eq [document, document1]
      end
    end
  end
end
