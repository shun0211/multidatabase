require 'prawn'

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]
  # layout 'special_articles'

  # GET /articles or /articles.json
  def index
    @articles = Article.all.order(Arel.sql('priority IS NULL ASC, priority ASC'))
    # @articles = Article.all.order(Arel.sql('priority IS NULL ASC, priority ASC'))
    # @articles = Article.all.order(Arel.sql('CASE WHEN priority IS NULL THEN 1 ELSE 0 END, priority ASC'))
    # @articles = Article.all.order(Arel.sql('ifnull(priority, 2147483647) ASC'))

    # @articles = Comment
    #   .default_comments
    #   .group(:article_id)
    #   .includes(:article)
    #   .select(:article_id, 'count(*) as c')
    #   .order(c: :desc)
    #   .map{_1.article}
  end

  # GET /articles/1 or /articles/1.json
  def show
    @article = Article.find(params[:id])
    @comments = @article.comments

    @html = "#{@article.title}"
  end

  # GET /articles/new
  def new
    @article = Article.new
    # redirect_back(fallback_location: root_path)
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article, notice: "Article was successfully created."
      user = User.last
      ArticleMailer.with(user: user).notice.deliver_later
      # puts message
      # sleep 10
      # ArticleMailer.with(user: User.last).notice.deliver_later
    else
      render_ajax_error model: @article
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content)
    end

    def download_pdf
      send_data generate_pdf,
                filename: "test.pdf",
                type: "application/pdf"
    end

    def generate_pdf
      Prawn::Document.new do
        text 'test', align: :center
        text "Address: Tokyo"
        text "Email: test@example.com"
      end.render
    end
end
