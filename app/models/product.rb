class Product < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :published, inclusion: { in: [true, false] }

  scope :published, -> { where(published: true) }
  scope :by_user, ->(user) { where(user: user) }
end
