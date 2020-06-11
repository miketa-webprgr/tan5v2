require "csv"

class WordnotesController < Base
  before_action :current_user


  def show
    @wordnote = User.find(params[:user_id]).wordnotes.find(params[:id])
    @tangos = @wordnote.tangos.all.order(id: :asc)
    @tango_config = @current_user.tango_config.find_by(wordnote_id: params[:id])
    if @tango_config == nil
      @tango_config = @current_user.tango_config.build(wordnote_id: params[:id],font_size: 20,filter: 0 )
    end
    if @tango_config.sort == "desc"
      @tangos = @tangos.reverse
    elsif @tango_config.sort == "random"
      @tangos = @tangos.shuffle
    end
    @tango_config.clicked_num += 1
    @tango_config.save
    tango_data = @current_user.tango_datum.where(wordnote_id: @wordnote.id)
    @tangos = @tangos.reject do |t|
      star = 0
      if tango_data.where(tango_id: t.id).first
        star = tango_data.where(tango_id: t.id).first.star 
      end
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
    @user = User.find(params[:user_id])
    @wordnote = @user.wordnotes.find(params[:wordnote_id])
    dl_data = CSV.generate do |csv|
      csv <<  %w(id question answer hint)
      @wordnote.tangos.all.order(id: :asc).each do |tango|
        csv << [ tango.id, tango.question, tango.answer, tango.hint ]
      end
    end
    send_data(dl_data, filename: "s.csv")

  end
  
  def upload_csv
    wordnote = @current_user.wordnotes.find(params[:wordnote_id])
    tangos = wordnote.tangos.all
    current_tangos_count = tangos.count
    new_tangos = []
    update_tangos = []
    id_dup_check = []
    now = Time.current
    CSV.foreach(params[:csv_file].path, headers: true, encoding: "utf-8") do |row|
      new_tangos << {id: row["id"].to_i, wordnote_id: wordnote.id, answer: row["answer"], question: row["question"], hint: row["hint"], created_at: now, updated_at: now}
    end
    new_tangos.delete_if do |new_tango|
      delete_flag = false
      tangos.each do |old_tango| 
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
            && old_tango.question == new_tango[:question] \
            && old_tango.hint == new_tango[:hint]
          delete_flag = true
          break
        end
      end
      delete_flag
    end
    new_tangos.map{|t| t.delete(:id) }
    id_dup_flag = true if (id_dup_check.count - id_dup_check.uniq.count) > 0
    #raise if id_dup_flag == true
    Tango.insert_all new_tangos if new_tangos.empty? == false
    Tango.upsert_all update_tangos if update_tangos.empty? == false
  end

  private def wordnote_params
    params.require(:wordnote).permit(:name,:subject,:is_open)
  end
end
