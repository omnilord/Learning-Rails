require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  def setup
    @user = User.find_by_username('ArticleGuy')
    @banned = User.find_by_username('Banned')
  end

  def teardown
    session[:user_id] = nil
  end

  test 'articles#index should succeed' do
    get :index
    assert_response :success
  end

  test 'articles#new should redirect when no user is logged in' do
    get :new
    assert_response :redirect # We are not logged in, so new is not possible
    assert_redirected_to articles_path
  end

  test 'articles#new should redirect when a banned user is logged in' do
    session[:user_id] = @banned.id
    get :new
    assert_response :redirect
    assert_redirected_to banned_path
  end

  test 'articles#new should success when appropriate user is logged in' do
    session[:user_id] = @user.id
    get :new
    assert_response :success
  end

  test 'articles#new should post to articles#create and a new article is created' do
    session[:user_id] = @user.id
    get :new
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post :create, article: {title: 'Valid title', body: 'This is a valid body.'}
    end
    @article = Article.last
    assert_not @article.nil?
    assert_response :redirect
    assert_redirected_to article_path(@article)
  end

  test 'articles#show should succeed' do
    session[:user_id] = @user.id
    @article = Article.create(title: 'Valid title', body: 'This is a valid body.', user: @user)
    get :show, id: @article.id
    assert_response :success
  end

  test 'articles#delete should remove the chosen article, but leave the rest' do
    session[:user_id] = @user.id
    @article = Article.create(title: 'Valid title 1', body: 'This is a valid body.', user: @user)
    @article = Article.create(title: 'Valid title 2', body: 'This is a valid body.', user: @user)
    @article = Article.create(title: 'Valid title 3', body: 'This is a valid body.', user: @user)
    delete_id = @article.id
    assert_difference 'Article.count', -1 do
      delete :destroy, id: delete_id
    end

    # verify the article was indeed removed
    Article.all.each do |a|
      assert_not a.id == delete_id
    end

    #check the end state
    assert_response :redirect
    assert_redirected_to articles_path
  end
end
