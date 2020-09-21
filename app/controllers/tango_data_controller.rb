class TangoDataController < Base
  before_action :current_user

  def change
  p params
    tango_datum = @current_user.tango_datum.find_by(tango_id: params[:id])
    if tango_datum == nil
      p tango_datum = @current_user.tango_datum.build(tango_id: params[:id], wordnote_id: params[:wordnote_id],wrong_num: 0, trial_num: 0, star: 0)
    end
    wrong_num = tango_datum.wrong_num
    trial_num = tango_datum.trial_num
    star = tango_datum.star
    wrong_num += 1 if params[:wrong_num]
    trial_num += 1 if params[:trial_num]
    star = params[:star].to_i if params[:star]
    p change_data = {wrong_num: wrong_num, trial_num: trial_num, star: star}
    
    if tango_datum.id == nil
      tango_datum.attributes = change_data
      tango_datum.save
    else
      tango_datum.update_columns(change_data)
    end
  end


  def get_tango_data
    @trial_count = 0
    @correct_ratio = 0
    @star = nil
    p tango_datum = @current_user.tango_datum.find_by(tango_id: params[:id])
    if tango_datum
      @trial_count = tango_datum.trial_num
      @correct_ratio = 1 - ( tango_datum.wrong_num.to_f / tango_datum.trial_num )
      @correct_ratio = (@correct_ratio * 100 ).round(2)
      @star = tango_datum.star
    end
  end

end
