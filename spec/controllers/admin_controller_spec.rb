require 'rails_helper'
# spec/controllers/admin_controller_spec.rb

RSpec.describe AdminController, type: :controller do
  describe "GET #dashboard" do
    it "assigns @users, @pending_users, and @approved_users" do
      admin_user = User.create(
        name: "Admin User",
        email: "admin@example.com",
        role: :admin,
        password: "admin_password",
        balance: 0.1e5,
        is_approved: false
      )

      non_approved_user = User.create(
        name: "Non-Admin User",
        email: "user@example.com",
        password: "user_password",
        role: :trader,
        is_approved: false,
        balance: 0.1e5
      )

      approved_user = User.create(
        name: "Non-Admina User",
        email: "usera@example.com",
        password: "user_password",
        role: :trader,
        is_approved: true,
        balance: 0.1e5
      )

      sign_in admin_user

      get :dashboard

      expect(assigns(:users)).to include(admin_user, non_approved_user, approved_user)
      expect(assigns(:pending_users)).to include(non_approved_user)
      expect(assigns(:approved_users)).to include(approved_user)
      expect(admin_user.admin?).to be(true)
    end

    it "should redirect to root_path for non-admin users" do
      non_admin_user = User.create(
        name: "Non-Admin User",
        email: "user@example.com",
        password: "user_password",
        role: :trader,
        is_approved: false,
        balance: 0.1e5
      )

      sign_in non_admin_user

      get :dashboard

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Access denied. You do not have permission to access the admin dashboard.')
    end
  end

  describe "POST #approve" do
    it "approves a user and sends an email" do
      admin_user = User.create(
        name: "Admin User",
        email: "admin@example.com",
        role: :admin,
        password: "admin_password"
      )

      user_to_approve = User.create(
        name: "User to Approve",
        email: "approve@example.com",
        password: "approve_password"
      )

      sign_in admin_user

      expect {
        post :approve, params: { id: user_to_approve.id }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)

      expect(user_to_approve.reload.is_approved).to be(true)

      email = ActionMailer::Base.deliveries.last
      expect(email.subject).to eq("Your Account Has Been Approved")
      expect(email.to).to eq([user_to_approve.email])
    end

    it "redirects to root_path for non-admin users" do
      non_admin_user = User.create(
        name: "Non-Admin User",
        email: "user@example.com",
        password: "user_password"
      )

      user_to_approve = User.create(
        name: "User to Approve",
        email: "approve@example.com",
        password: "approve_password"
      )

      sign_in non_admin_user

      post :approve, params: { id: user_to_approve.id }

      expect(response).to redirect_to(root_path)
    end
  end

  describe "GET #edit_role" do
    it "renders the 'admin/_edit' partial" do
      admin_user = User.create(
        name: "Admin User",
        email: "admin@example.com",
        role: :admin,
        password: "admin_password"
      )

      sign_in admin_user

      user_to_edit = User.create(
        name: "User to Edit",
        email: "edit@example.com",
        password: "edit_password"
      )

      get :edit_role, params: { id: user_to_edit.id }

      expect(response).to render_template(partial: 'admin/_edit') # Adjust partial name as needed
      expect(assigns(:user)).to eq(user_to_edit)
    end
  end

  describe "PATCH #update_role" do
  it "updates the user's role and redirects to the dashboard" do
    admin_user = User.create(
      name: "Admin User",
      email: "admin@example.com",
      role: :admin,
      password: "admin_password"
    )
  
    sign_in admin_user
  
    user_to_edit = User.create(
      name: "User to Edit",
      email: "edit@example.com",
      password: "edit_password"
    )
  
    new_role = "trader" # Use a symbol for the role value
  
    patch :update_role, params: { id: user_to_edit.id, user: { role: new_role } }
  
    expect(response).to redirect_to(dashboard_path)
    expect(flash[:notice]).to eq("Role updated successfully.")
    expect(user_to_edit.reload.role).to eq(new_role)
  end
  

    it "renders 'edit_role' template if role update fails" do
      admin_user = User.create(
        name: "Admin User",
        email: "admin@example.com",
        role: :admin,
        password: "admin_password"
      )

      sign_in admin_user

      user_to_edit = User.create(
        name: "User to Edit",
        email: "edit@example.com",
        password: "edit_password"
      )

      invalid_role = :admin # Use a valid role value from your application

      patch :update_role, params: { id: user_to_edit.id, user: { role: invalid_role } }

      expect(assigns(:user)).to eq(user_to_edit)
    end
  end
  describe 'GET #edit' do
    it 'finds the correct user by ID' do
      # Create a test user
      user = User.create(email: 'test@example.com', password: 'password123')

      # Debugging: Print user ID and params[:id]
      puts "User ID: #{user.id}"

      # Simulate a request to the edit action with the user's ID
      get :edit, params: { id: user.id }

      # Debugging: Print assigns(:user) to see what it is
      puts "Assigned User: #{assigns(:user).inspect}"

      # Check that the user is assigned correctly
      expect(assigns(:user)).to eq(user)
    end
  end
end
