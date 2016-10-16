require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def setup
    @user = User.find_by_username('ArticleGuy')
    @articles = Article.create([
      {
        title: 'Article #1',
        body: 'This is what a body looks like.',
        user: @user,
        tags: ['f', 'B']
      },
      {
        title: 'Article #2',
        body: 'This is what a body looks like, also.',
        user: @user,
        tags: ['b', 'c', 'd']
      },
      {
        title: 'Article #3',
        body: 'They make your ass look big.',
        user: @user,
        tags: ['f', 'b', 'e']
      },
      {
        title: 'Atari owns all',
        body: 'We have so much candy, it tastes good.',
        user: @user,
        tags: []
      }
    ])
  end

  test 'A simple search' do
    get :search, q: 'Atari'
    assert_response :success, 'should succeed with a 200 code'
    # assert_??? x === '[{"title":"Atari owns all","body":"We have so much candy, it tastes good."....}]', 'should return an empty array'
  end

  test 'An empty get' do
    get :search
    assert_response 400, 'should fail with a 400 - Bad Request'
  end

  test 'A request for a non-existing term' do
    get :search, q: 'foobarbaz'
    assert_response :success, 'should succeed with a 200 code'
    # assert_??? x === '[]', 'should return an empty array'
  end

  test 'A request for a multiple articles' do
    get :search, q: 'b'
    assert_response :success, 'should succeed with a 200 code'
    # ???
  end
end
