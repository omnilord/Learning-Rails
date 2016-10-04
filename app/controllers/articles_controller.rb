class ArticlesController  < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :set_tags, only: [:new, :edit]
  before_action only: [:new, :create] { |c| c.require_user(articles_path) }
  before_action only: [:edit, :update, :destroy]  { |c| c.require_user(article_path(@article)) }
  before_action :allow_edit, only: [:edit, :update]
  before_action :allow_destroy, only: [:destroy]


  helper_method :edit_allowed?, :destroy_allowed?

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
    @article.user = current_user
    if @article.save
      flash[:success] = 'Article successfully saved!'
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end

  def update
    aParams = article_params
    aParams[:tags] = nil if aParams[:tags].nil? && params[:tags_check] != ''
    if @article.update(aParams)
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

  def tags
    @tags = Tag.order(volume: :desc, tag: :asc).paginate(page: params[:page], per_page: 48)
  end

  def tag
    t = params[:tag]
    @tag = Tag.find_by_tag(t)
    @articles = Article.where('? = ANY (tags)', t)
                       .order(updated_at: :desc)
                       .paginate(page: params[:page], per_page: 10)
  end


  private

  def set_article
    @article = Article.find(params[:id])
  end

  def set_tags
    @tags = Tag.order(volume: :desc, tag: :asc).map { |t| t[:tag] }
  end

  def article_params
    params.require(:article).permit(:title, :body, tags: [])
  end

  def edit_allowed?(user_id = @article.user_id)
    logged_in? && (user_id == current_user.id || current_user.privilege >= User::PRIV_SR_USER)
  end

  def allow_edit
    redirect_to article_path(@article) unless edit_allowed?
  end

  def destroy_allowed?(user_id = @article.user_id)
    logged_in? && (user_id == current_user.id || current_user.privilege >= User::PRIV_MOD)
  end

  def allow_destroy
    redirect_to user_path(@user) unless destroy_allowed?
  end
end
