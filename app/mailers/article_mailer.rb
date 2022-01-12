class ArticleMailer < ApplicationMailer
  def notice
    @user = params[:user]
    mail(to: @user.email, subject: '記事が投稿されました！')
  end
end
