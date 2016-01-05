module ApplicationHelper
  # Role check helper
  ["discjockey", "audience"].each do |mode|
    define_method "#{mode}?" do
      cookies[:mode].eql? mode
    end
  end

  # Humanize and titleize mode
  def label(mode, opposite=false)
    case mode
      when "discjockey" then (opposite ? "Audience" : "DiscJockey")
      when "audience" then (opposite ? "DiscJockey" : "Audience")
    end
  end
end
