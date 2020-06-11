module ApplicationHelper
  def view_title
    if @title
      return @title + " | tan5"
    else
      return "tan5"
    end
  end
end
