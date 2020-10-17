class TangoConfig < ApplicationRecord
  belongs_to :user
  belongs_to :wordnote

  def sort_by_setting
    # 本当はselfって不要なんですが、分かりやすいかなと思って一応つけてます
    # 例： self.sort when 'desc'により、tango_configインスタンスのsortというattributeが'desc'合致するか判定する
    case self.sort
    when 'desc'
      wordnote.tangos.desc_with_datum
    when 'random'
      wordnote.tangos.random_with_datum
    else
      wordnote.tangos.asc_with_datum
    end
  end
end
