# frozen_string_literal: true

class Link < ApplicationRecord
  GIST_URL = /gist.github.com/.freeze
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: %r{\A(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,63}(:[0-9]{1,5})?(/.*)?\z}ix, message: '%{value} is invalid' }

  def gist?
    url =~ GIST_URL
  end
end
