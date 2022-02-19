class ArticleMailer < ApplicationMailer
  def notice
    attachments.inline['image.pdf'] = File.read("#{Rails.root}/public/sample.pdf")
    @user = params[:user]
    mail(to: @user.email, subject: '記事が投稿されました！')
  end
end
