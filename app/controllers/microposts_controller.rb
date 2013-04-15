class MicropostsController < ApplicationController

  #在执行某个method之前 先执行相关函数，类似于before_save
  before_filter :signed_in_user, :only=> [:create, :destroy]
  before_filter :correct_user,   :only=> :destroy

  def index
  end

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
     current_user.microposts.find_by_id(params[:id]).destroy
     redirect_to root_path
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end

end
