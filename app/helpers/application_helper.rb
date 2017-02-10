module ApplicationHelper
  def alert_class(type)
    case type
    when 'notice' then 'alert alert-info'
    when 'alert' then 'alert alert-danger'
    else "alert alert-#{type}"
    end
  end
end
