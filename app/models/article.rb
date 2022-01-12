class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true

  scope :recent, -> { where("created_at > '#{3.days.ago}'") }
  # scope :public_articles, -> { where(is_public: true) if false }

  def self.public_articles
    where(is_public: true) if false
  end
end
