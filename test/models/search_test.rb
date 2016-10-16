require 'test_helper'

class SearchTest < ActiveSupport::TestCase
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

  test 'search for articles by title' do
    s1 = Search.query('foo')
    assert_equal 0, s1.length, 'should return none for missing'

    s2 = Search.query('Atari')
    assert_equal 1, s2.length, 'should return 1'

    s3 = Search.query('Article')
    assert_equal 3, s3.length, 'should return 3'
  end

  test 'search for articles by body' do
    s1 = Search.query('bar')
    assert_equal 0, s1.length, 'Returns none for missing'

    s2 = Search.query('ass')
    assert_equal 1, s2.length, 'should return 1'

    s3 = Search.query('body')
    assert_equal 2, s3.length, 'should return 2'
  end

  test 'search for articles by tags' do
    s1 = Search.query('m')
    assert_equal 0, s1.length, 'Returns none for missing'

    s2 = Search.query('e')
    assert_equal 1, s2.length, 'should return 1'

    s3 = Search.query('f')
    assert_equal 2, s3.length, 'should return 2'

    s4 = Search.query('b')
    assert_equal 3, s4.length, 'should return 3'
  end

  test 'load source from search' do
    s1 = Search.query('body')
    assert_equal 2, s1.length, 'should return 2'
    s1.each do |s|
      assert_equal 'Article', s.source.class.name, 'Class name for source in search should be "Article"'
    end

    s2 = Search.query('f')
    assert_equal 2, s2.length, 'should return 2'
    s2.each do |s|
      assert_equal 'Article', s.source.class.name, 'Class name for source in search should be "Article"'
    end
  end
end
