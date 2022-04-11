class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  scope :recent, -> { where("created_at > '#{30.days.ago}'") }
  scope :public_comments, -> { where(is_public: true) }
  scope :default_comments, -> { recent.public_comments }

  def is_comment_by?(user)
    user_id == user.id
  end
end
