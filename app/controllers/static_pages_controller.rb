class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build 
    @feed_items = current_user.feed.page(params[:page]).per Settings.user_per_page
  end

  def help
  end
end
