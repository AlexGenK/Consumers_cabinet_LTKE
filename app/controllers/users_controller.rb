class UsersController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user, only: [:update, :destroy, :edit]

	 def index
    @users = User.order(:name)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:admin_role, :manager_role, :client_role, :name, :email, :phone)
  end
end
