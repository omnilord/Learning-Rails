require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  def setup
    @user = User.find_by_username('ArticleGuy')
    @article = Article.new()
    @article.user = @user
  end

  test 'Check validation constraints on title' do
    @article.body = 'a' * 11

    assert_not @article.valid?, 'Invalid article when empty'
    @article.title = 'a'
    assert_not @article.valid?, 'Article should not validate a title shorter than 3 characters'
    @article.title = 'a' * 256
    assert_not @article.valid?, 'Article should not validate a title longer than 255 characters'
    @article.title = 'a' * 100
    assert @article.valid?, 'Article should be valid with a title between 3 and 255 characters'
  end

  test 'Check validation constraints on body' do
    @article.title = 'a' * 100

    @article.body = 'a' * 9
    assert_not @article.valid?, 'Article should not validate a body shorter than 10 characters'
    @article.body = 'a' * 1025
    assert_not @article.valid?, 'Article should not validate a body longer than 1024 characters'
    @article.body = 'a' * 100
    assert @article.valid?, 'Article should be valid with a body between 3 and 255 characters'
  end

  test 'Create a valid article' do
    @article.title = 'Valid title'
    @article.body = 'This is a valid body.'
    @article.user = @user
    assert @article.valid?, 'Valid articles should be valid.'
    assert @article.save, 'Valid articles should save.'
  end
end
