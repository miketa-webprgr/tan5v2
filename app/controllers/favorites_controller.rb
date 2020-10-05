class FavoritesController < Base
  before_action :current_user

  def change
    @favorite = @current_user.favorite.find_by(wordnote_id: params[:wordnote_id])
    @wordnote_id = params[:wordnote_id]
    if @favorite
      @favorite.destroy
      render action: "destroy" if @current_user.id.to_s == params[:user_id]
    else
      @current_user.favorite.build(wordnote_id: params[:wordnote_id]).save
    end
  end
end
