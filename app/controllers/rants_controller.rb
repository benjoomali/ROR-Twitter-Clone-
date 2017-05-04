class RantsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy 
  
  def create 
    @rant = current_user.rants.build(rant_params)
    if @rant.save 
      flash[:success] = "Nice rant."
      redirect_to root_url
    else 
      @feed_items = []
      render 'static_pages/home'
    end 
  end
  
  def destroy
    @rant.destroy 
    flash[:success] = "Rant deleted"
    #redirect back to page that issued delete request
    redirect_to request.referrer || root_url
  end 
  
  private 
  
    def rant_params
      params.require(:rant).permit(:content)
    end 
  
    def correct_user
      @rant = current_user.rants.find_by(id: params[:id])
      redirect_to root_url if @rant.nil?
    end 
end
