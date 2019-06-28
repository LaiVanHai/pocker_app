require 'rails_helper'

RSpec.describe PockersController, type: :controller do
  describe "GET top" do
		it "Responds successfully" do
			get	:top
			expect(response).to	be_successful
		end

    it "Renders the :top view" do
      get :top
      expect(response).to render_template :top
    end
	end

  describe "POST check" do
    it "Renders the :top view" do
      post :check, params: {card_list: 'C7 C6 C5 C4 C3'}
      expect(response).to render_template :top
    end
 end
end
