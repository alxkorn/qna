# frozen_string_literal: true

module ApplicationHelper
  def flash_helper
    flash_messages = flash.map { |key, value| content_tag :p, sanitize(value), class: "flash #{key}" }
    flash_messages.join.html_safe
  end

  def vote_style(user, resource)
    ('display: none' if resource.voted_by?(user)).to_s
  end

  def cancel_vote_style(user, resource)
    ('display: none' unless resource.voted_by?(user)).to_s
  end
end
