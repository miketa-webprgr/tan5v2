class TopController < Base
  def index
    current_user
    if @current_user
      redirect_to user_path(@current_user)
    else
      render action: "index"
    end
  end
end
