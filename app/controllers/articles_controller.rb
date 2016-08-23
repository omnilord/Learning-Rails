class ArticlesController  < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action only: [:new, :create] { |c| c.require_user(articles_path) }
  before_action only: [:edit, :update, :destroy]  { |c| c.require_user(article_path(@article)) }

  def set_article
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.order(updated_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def new
    @article = Article.new
  end

  def edit
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      flash[:success] = 'Article successfully saved!'
      redirect_to article_path(@article)
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = 'Article successfully updated!'
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    flash[:danger] = "'#{@article.title}' Article successfully deleted."
    redirect_to articles_path
  end

  def show
  end

  private

  def article_params
    params.require(:article).permit(:title, :body, :tags => [])
  end
end
