class TangosController < Base
  before_action :current_user

  def index
    @user = User.find(params[:user_id])
    @tangos = @user.tangos.where(name: params[:key].first).where( subject: params[:key].last).order(created_at: :asc)
    if @tangos.size == 0
      flash[:danger] = "当該の単語帳はありません" 
      redirect_to user_path(@current_user) 
    end
  end

  def update
    @wordnote = @current_user.wordnotes.find(params[:wordnote_id])
    @tango = @wordnote.tangos.find(params[:id])
    @tango.update(tango_params)
  end

  def create_on_list
    @user = User.find(params[:user_id])
    @wordnote = @user.wordnotes.find(params[:wordnote_id])
    @tango = @wordnote.tangos.new(tango_params)
    unless tango_params[:question] == "" || tango_params[:answer] == ""
      @tango.save
    else
      render action: "create_on_list_error"
    end
  end

  def create 
   @user = User.find(params[:user_id])
   @tango = @user.wordnotes.find(params[:wordnote_id]).tangos.new(tango_params)
   @wordnotes = @user.wordnotes.all
   @tango.save
  end  

  def destroy
    @user = User.find(params[:user_id])
    delete_tangos = @user.tangos.where(name: params[:key].first).where( subject: params[:key].last)
    @tango_name = delete_tangos.first.name
    delete_tangos.destroy_all
    renewed_tangos = @user.tangos.all.order(updated_at: :asc)
    @classified_tango = classify_tangos(renewed_tangos)
    respond_to do |format|
      format.html { redirect_to :root}
      format.js
    end
  end

  def delete_checked_tangos
   @delete_tangos = @current_user.wordnotes.find(params[:wordnote_id]).tangos.find(params[:tangos])
   @tango_json = @delete_tangos.to_json.html_safe
   @delete_tangos.each{|tango| tango.destroy}
  end

  private 
    def tango_csv_params
      params.require(:tango)
    end

    def tango_params
      params.require(:tango).permit(:wordnote_id,:question,:answer,:hint)
    end
end
