class UserlocksController < ApplicationController
  authorize_resource class: :userlock

  def index
    @users = User.all.order("locked_at DESC")
  end

  def lock
    user = User.find(params[:id])

    if user == current_user
      respond_to do |format|
        format.html { redirect_to({ action: "index" }, alert: "You cannot lock yourself.") }
        format.json { head :bad_request }
      end
      return
    end

    user.lock_access!

    respond_to do |format|
      format.html { redirect_to({ action: "index" }, notice: "#{user.name} was successfully locked.") }
      format.json { head :no_content }
    end
  end
  def unlock
    user = User.find(params[:id])

    if user == current_user
      respond_to do |format|
        format.html { redirect_to({ action: "index" }, alert: "You cannot unlock yourself.") }
        format.json { head :bad_request }
      end
      return
    end

    user.unlock_access!

    respond_to do |format|
      format.html { redirect_to({ action: "index" }, notice: "#{user.name} was successfully unlocked.") }
      format.json { head :no_content }
    end
  end
end
