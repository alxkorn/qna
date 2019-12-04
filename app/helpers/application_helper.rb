module ApplicationHelper
  def flash_helper
    flash_messages = flash.map { |key, value| content_tag :p, sanitize(value), class: "flash #{key}" }
    flash_messages.join.html_safe
  end
end
