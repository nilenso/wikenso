require 'spec_helper'

describe Admin::WelcomePagesController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "assigns the latest welcome page" do
      welcome_page = create(:welcome_page)
      get "new"
      assigns(:existing_welcome_page).should == welcome_page
    end

    it "assigns a new welcome page" do
      get "new"
      assigns(:welcome_page).should be_a WelcomePage
    end
  end

  describe "GET 'create'" do
    it "creates a new welcome page" do
      welcome_page_params = attributes_for(:welcome_page)
      expect { post :create, welcome_page: welcome_page_params }.to change { WelcomePage.count }.by(1)
    end

    it "saves the welcome page's title" do
      welcome_page_params = attributes_for(:welcome_page, title: "Foo")
      post :create, welcome_page: welcome_page_params
      WelcomePage.last.title.should == "Foo"
    end

    it "saves the welcome page's text" do
      welcome_page_params = attributes_for(:welcome_page, text: "Foo")
      post :create, welcome_page: welcome_page_params
      WelcomePage.last.text.should == "Foo"
    end

    context "when the save is successful" do
      it "redirects to the statistics page" do
        welcome_page_params = attributes_for(:welcome_page)
        post :create, welcome_page: welcome_page_params
        response.should redirect_to admin_statistics_path
      end

      it "sets a flash notice" do
        welcome_page_params = attributes_for(:welcome_page)
        post :create, welcome_page: welcome_page_params
        flash[:notice].should_not be_empty
      end
    end

    context "when the save is unsuccessful" do
      before(:each) do
        WelcomePage.any_instance.stub(:save).and_return(false)
      end

      it "renders the `new` action" do
        welcome_page_params = attributes_for(:welcome_page)
        post :create, welcome_page: welcome_page_params
        response.should render_template :new
      end

      it "sets a flash error" do
        welcome_page_params = attributes_for(:welcome_page)
        post :create, welcome_page: welcome_page_params
        flash[:error].should_not be_empty
      end

      it "assigns the welcome page" do
        welcome_page_params = attributes_for(:welcome_page)
        post :create, welcome_page: welcome_page_params
        assigns(:welcome_page).should be_a WelcomePage
      end
    end
  end
end
