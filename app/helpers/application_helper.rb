module ApplicationHelper
  def alert_class(type)
    case type
      when :alert
        "alert alert-warning"
      when :error
        "alert alert-danger"
      when :notice
        "alert alert-info"
      when :success
        "alert alert-success"
      else
        "alert alert-info"
    end
  end

  def nav_link(link_text, link_path)
    class_name = request.fullpath.start_with?(link_path) ? 'active' : ''
    
    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end

  def html_obfuscate(string)
    encoded_chars = []
    string.each_char do |char| 
      encoded_chars << "&##{char[0].ord};"
    end
    encoded_chars.join
  end
end
