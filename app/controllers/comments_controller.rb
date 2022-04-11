class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    comment = @article.comments.build(content: params[:content], user: User.first)
    comment.save
    redirect_to article_path(@article)
  end
end
