class ApplicationController < ActionController::Base
  before_action :set_turbolinks_header
  def set_turbolinks_header
   response.set_header('Turbolinks-Location', request.fullpath)
  end
  private def classify_tangos(tangos)
    classified_tangos = {}
    tangos.each do |tango|
      key = [tango.name,tango.subject]
      classified_tangos[key] = {} if classified_tangos[key] == nil
      created_at = tango.created_at
      updated_at = tango.updated_at
      num = 1
      num = classified_tangos[key][:num] + 1 if classified_tangos[key][:num]
      classified_tangos[key] = {
        created_at: created_at,
        updated_at: updated_at,
        num: num
      }
    end
    classified_tangos
  end

end
