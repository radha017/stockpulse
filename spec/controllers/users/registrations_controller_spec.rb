require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end
 
  

  describe "POST #create" do
    it "creates a new user" do
        expect do
        post :create, params: {
            user: { email: "test@example.com", password: "password", name: "John Doe" }
        }
        end.to change(User, :count).by(1)
    
        new_user = User.last
        expect(new_user.name).to eq("John Doe")
        expect(response).to redirect_to(root_path)
  end

    it "renders errors for invalid input" do
      post :create, params: { user: { email: "", password: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    
  end
end