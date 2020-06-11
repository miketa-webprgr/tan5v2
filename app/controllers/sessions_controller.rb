class SessionsController < Base
  def new
    if current_user
      redirect_to :root
    else
      @form = LoginForm.new
      render action: "new"
    end

  end

  def create
    @form = LoginForm.new(login_form_params)
    if @form.email.present?
      user = User.find_by("LOWER(email) = ?", @form.email.downcase)
    end
    if true #Authenticator.new(user).authenticate(@form.password)
      session[:user_id] = user.id
      flash[:success] = "ログイン成功"
      redirect_to user_path(id: user.id)
    else
      flash.now[:danger] = "入力エラー"
      render action: "new"
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:success] = "ログアウトしました"
    redirect_to :root
  end

  private def login_form_params
    params.require(:login_form).permit(:email,:password)
  end
end
