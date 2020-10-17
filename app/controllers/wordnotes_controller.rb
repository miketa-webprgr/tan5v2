require "csv"

class WordnotesController < Base
  before_action :current_user

  def show
    @user = User.find(params[:user_id])
    @wordnote = @user.wordnotes.find(params[:id])
    @tango_config = @current_user.tango_config.find_by(wordnote_id: params[:id])
    @tango_config = @current_user.tango_config.build(wordnote_id: params[:id],font_size: 32,filter: 0 ) if @tango_config == nil
    @tango_config.clicked_num += 1
    @tango_config.save

    # コメントアウトした場所を上書きした
    @tangos = @tango_config.sort_by_setting

    # case @tango_config.sort
    # when "desc"
    #   @tangos = @wordnote.tangos.desc_with_datum
    # when "random"
    #   @tangos = @wordnote.tangos.random_with_datum
    # else 
    #   @tangos = @wordnote.tangos.asc_with_datum
    # end

    @tangos = @tangos.reject do |tango|
      star = 0
      star = tango.tango_datum.first.star if tango.tango_datum.first # tango has_one tango_datum に変更すべし
      star < @tango_config.filter.to_i
    end

    if @tangos.size == 0
      flash[:success] = "表示できる単語がありません。"
      redirect_to :root
    end
  end

  def create
    @wordnote = @current_user.wordnotes.new(wordnote_params)
    @user = @current_user
    if @wordnote.save
      @wordnotes = @user.wordnotes.all
    end
  end

  def update
    @wordnote = @current_user.wordnotes.find(params[:id])
    @wordnote.attributes = wordnote_params
    @wordnote.save
  end

  def destroy
    @user = User.find(params[:user_id])
    @wordnote = @user.wordnotes.find(params[:id])
    @wordnotes = @user.wordnotes.all
    @wordnote.destroy
  end

  def download_csv
    #本人以外がDLできるかは後で設定
    @user = User.find(params[:user_id])
    @wordnote = @user.wordnotes.find(params[:wordnote_id])
    explain_str = "#このファイルをアップロードする場合、IDが一致している単語はその単語を修正します。answerとquestionの組み合わせがすでに存在する単語ペアはアップロードされません。この行は削除しないでください。"
    dl_data = CSV.generate do |csv|
      csv <<  ["id", "question", "answer", "hint", explain_str]
      @wordnote.tangos.each do |tango|
        csv << [ tango.id, tango.question, tango.answer, tango.hint ]
      end
    end
    send_data(dl_data, filename: "#{@wordnote.name + "-" + @wordnote.subject}.csv")
  end
  
  def upload_csv
    return @no_file_error = true if params[:csv_file] == nil
    return @file_size_error = true if params[:csv_file].size > 500000

    wordnote = @current_user.wordnotes.find(params[:wordnote_id])
    @tangos = wordnote.tangos.all
    current_tangos_count = @tangos.count

    new_tangos = []
    update_tangos = []
    id_dup_check = []
    now = Time.current

    CSV.foreach(params[:csv_file].path, headers: true, encoding: "utf-8") do |row|
      new_tangos << {id: row["id"].to_i, wordnote_id: wordnote.id, answer: row["answer"], question: row["question"], hint: row["hint"], created_at: now, updated_at: now}
    end
    new_tangos.delete_if do |new_tango|
      delete_flag = false
      @tangos.each do |old_tango| 
        if old_tango.id == new_tango[:id]
          delete_flag = true
          unless old_tango.answer == new_tango[:answer] \
              && old_tango.question == new_tango[:question] \
              && old_tango.hint == new_tango[:hint]
            update_tangos << new_tango
            id_dup_check << new_tango[:id]
          end
          break
        elsif old_tango.answer == new_tango[:answer] \
            && old_tango.question == new_tango[:question]
          delete_flag = true
          break
        end
      end
      delete_flag  #ここがtrueなら削除
    end
    new_tangos.map{|t| t.delete(:id) }
    id_dup_flag = true if (id_dup_check.count - id_dup_check.uniq.count) > 0
    #raise if id_dup_flag == true
    begin 
      @tangos.insert_all new_tangos if new_tangos.empty? == false
      @tangos.upsert_all update_tangos if update_tangos.empty? == false
    rescue => error
      @error = error.class.to_s.split("::").last
      render action: "upload_csv"
    end
  end

  private def wordnote_params
    params.require(:wordnote).permit(:name,:subject,:is_open)
  end
end
