class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "flash.success"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "flash.del_success"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t "flash.del_fail"
      redirect_to request.referrer
    end
  end

  private
    def micropost_params
      params.require(:micropost).permit :content, :picture
    end

    def correct_user
      @micropost = current_user.microposts.find_by id: params[:id]
      return unless @micropost.nil?
      flash[:info] = t "flash.no_micropost"
      redirect_to root_url
    end
end
