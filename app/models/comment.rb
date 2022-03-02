class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  def is_comment_by?(user)
    # self.user == user
    user_id == user.id
  end
end
