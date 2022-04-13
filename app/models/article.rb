class Article < ApplicationRecord
  has_many :comments
  has_many :public_comments, -> { where is_public: true }, class_name: 'Comment'

  validates :title, presence: true
  validates :content, presence: true

  scope :recent, -> { where("created_at > '#{3.days.ago}'") }
  scope :public_articles, -> { where(is_public: true) }

  enum priority: {
    important: 10,
    normal: 20,
    light: 30
  }

  def self.public_articles
    where(is_public: true) if false
  end

  def commented_by?(user)
    comments.pluck(:user_id).include?(user.id)
  end

  def self.sort_by_comment_count_before
    self
      .includes(:comments)
      .select('*', "(SELECT COUNT(comments.id) FROM comments WHERE articles.id = comments.article_id AND created_at > '#{30.days.ago}' AND comments.is_public = TRUE) AS comment_count")
      .order(comment_count: :desc)
  end

  # SELECT *, (SELECT COUNT(comments.id) FROM comments WHERE articles.id = comments.article_id) AS comment_count FROM `articles` ORDER BY `comment_count` DESC

  # fromメソッドで書いてみる
  def self.sort_by_comment_count_after
    self
      .includes(:comments)
      .from(Comment.where('articles.id = comments.article_id').default_comments, :subquery)
      .order(comment_count: :desc)
  end
end



# MEMO
# Topic.select('title').from(Topic.approved)

# SELECT title FROM (SELECT * FROM topics WHERE approved = 't') subquery

# Topic.select('a.title').from(Topic.approved, :a)
# SELECT a.title FROM (SELECT * FROM topics WHERE approved = 't') a

# SELECT *, (SELECT COUNT(comments.id) FROM comments WHERE articles.id = comments.article_id) AS comment_count FROM `articles` ORDER BY `comment_count` DESC
# Comment.count.from(Comment.where('articles.id = comments.article_id').default_comments)

# 正規のSQL
# "SELECT *, (SELECT COUNT(comments.id) FROM comments WHERE articles.id = comments.article_id) AS comment_count FROM `articles` ORDER BY `comment_count` DESC"
# "SELECT *, COUNT(subquery.id) comment_count FROM (SELECT `comments`.* FROM `comments` WHERE (articles.id = comments.article_id) AND (created_at > '2022-04-02 08:56:33 +0900') AND `comments`.`is_public` = TRUE) subquery ORDER BY `comment_count` DESC"

# (SELECT COUNT(comments.id) FROM comments WHERE articles.id = comments.article_id)
