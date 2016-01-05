class Song < ApplicationRecord
  validates :title, :file, uniqueness: true

  before_create { self.slug = self.title.parameterize }
end
