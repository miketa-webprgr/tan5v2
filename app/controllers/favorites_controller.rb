class FavoritesController < Base
  before_action :current_user

  def change
    @favorite = @current_user.favorite.find_by(wordnote_id: favorite_params[:wordnote_id])
    @wordnote_id = favorite_params[:wordnote_id]
    if @favorite
      @favorite.destroy
      render action: "destroy" if @current_user.id.to_s == favorite_params[:user_id]
    else
      @current_user.favorite.build(wordnote_id: favorite_params[:wordnote_id]).save
    end
  end

  private 
    def favorite_params
      params.require(:favorite).permit(:user_id, :wordnote_id)
    end
end
