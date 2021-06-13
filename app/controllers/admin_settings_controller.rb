class AdminSettingsController < ApplicationController
  authorize_resource class: :admin_user

  def index
    @users = User.all.order("is_admin DESC")
  end

  def privilege
    user = User.find(params[:id])

    if user == current_user
      respond_to do |format|
        format.html { redirect_to({ action: "index" }, alert: "You cannot privilege yourself.") }
        format.json { head :bad_request }
      end
      return
    end

    user.update!(is_admin: true)

    respond_to do |format|
      format.html { redirect_to({ action: "index" }, notice: "#{user.name} became successfully an administrator.") }
      format.json { head :no_content }
    end
  end

  def unprivilege
    user = User.find(params[:id])

    if user == current_user
      respond_to do |format|
        format.html { redirect_to({ action: "index" }, alert: "You cannot unprivilege yourself.") }
        format.json { head :bad_request }
      end
      return
    end

    user.update!(is_admin: false)

    respond_to do |format|
      format.html { redirect_to({ action: "index" }, notice: "#{user.name}'s privilege was successfully withdrawn.") }
      format.json { head :no_content }
    end
  end
end
