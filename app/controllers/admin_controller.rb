class AdminController < ApplicationController
  before_action :require_admin
  def dashboard
    @users = User.all
    @pending_users = User.where(is_approved: false)
    @approved_users = User.where(is_approved: true)
  end

  def approve
    user = User.find(params[:id])
    user.update(is_approved: true)
    UserMailer.approved_email(user).deliver_now 
    redirect_to dashboard_path, notice: "#{user.email} has been approved."
  end
  


  def update_role
    @user = User.find(params[:id])
     @user.update(user_params)
      redirect_to dashboard_path, notice: "Role updated successfully."
    
  end

  def edit
    @user = User.find(params[:id])
    
  end

  private

  def require_admin
    unless current_user && current_user.admin?
      flash[:alert] = 'Access denied. You do not have permission to access the admin dashboard.'
      redirect_to root_path
      end
  end

  def user_params
    params.require(:user).permit(:role, :name, :email)
  end
  

end

