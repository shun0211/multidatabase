class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :content, presence: true

  scope :recent, -> { where("created_at > '#{3.days.ago}'") }
  # scope :public_articles, -> { where(is_public: true) if false }

  def self.public_articles
    where(is_public: true) if false
  end

  def commented_by?(user)
    # comments.where(user: user).present?
    # comments.where(user_id: user.id).present?
    comments.pluck(:user_id).include?(user.id)
  end
end
