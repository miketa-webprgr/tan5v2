class FavoritesController < Base
  before_action :current_user

  def change
    @current_user = User.find(favorite_params[:current_user_id])
    @favorite = @current_user.favorite.find_by(wordnote_id: favorite_params[:wordnote_id])
    if @favorite
      @favorite.destroy
    else
      @current_user.favorite.build(wordnote_id: favorite_params[:wordnote_id]).save
    end
  end

  private

    def favorite_params
      params.require(:favorite).permit(:user_id, :wordnote_id, :current_user_id)
    end
end
