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
    @save = false
    if Authenticator.new(user).authenticate(@form.password)
      session[:user_id] = user.id
      @save = true
      flash[:success] = "ログイン成功"
    else
      flash[:danger] = "パスワードかメールアドレスのいずれかが間違っています。"
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
