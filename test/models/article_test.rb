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


  test 'Testing tag saving on articles, part 1: article' do
    @article.title = 'Valid title'
    @article.body = 'This is a valid body.'
    @article.user = @user
    @article.tags = [] #testing that empty saves properly

    assert @article.valid?, 'Empty tags array should be valid.'
    assert @article.save, 'Article should save with no tags.'
    assert @article.tags.length == 0, 'No tags should be present on article after saving without tags.'

    @article.tags = ['Mlem']
    assert @article.save, 'Article should save update with one tag.'
    assert @article.tags.length == 1, 'One tag should be present on article after saving with one tag.'

    @article.tags << 'derp'
    assert @article.save, 'Article should save update with two tag.'
    assert @article.tags.length == 2, 'Two tags should be present on article after saving with two tags.'

    # This next line is a bit convolutied, but for documenting that
    # at present, the tags array will allow duplicate values if the array
    # is dereferenced and appended (<<) to directly.  Only set the tags
    # attribute with = to ensure proper trigger calls.
    @article.tags = @article.tags << 'derp'
    assert @article.tags.length == 2, 'Duplicate tags should be removed.'
    assert_not @article.changed?, 'Duplicate tags should not trigger a dirty state.'

    @article.tags = nil
    assert @article.save, 'Article should save when updated with no tags.'
    assert @article.tags.length == 0, 'All tags should be removed.'
  end


  test 'Testing tag saving on articles, part 2: database tags triggers, single save' do
    @article.title = 'Valid title'
    @article.body = 'This is a valid body.'
    @article.user = @user
    @article.tags = nil #[] #testing that empty saves properly
    @article.save
    assert Tag.count == 0, 'There should not be any tags to start.'

    test_tags = ['foo', 'bar', 'baz', 'derp', 'mlem']

    # when a single tag is saved...
    @article.tags = [test_tags[0]]
    @article.save
    assert Tag.count == 1, 'One tag should exist'
    t = Tag.first
    assert  t[:tag] == 'foo' && t[:volume] == 1, 'There should only be 1 tag recorded for "foo"'

    # when two tags are saved...
    @article.tags = test_tags[0..1]
    @article.save
    assert Tag.count == 2, 'Two tags should exist'
    t = Tag.find_by_tag('foo')
    assert t[:volume] == 1, 'There should only be 1 tag recorded for "foo"'
    t = Tag.find_by_tag('bar')
    assert t[:volume] == 1, 'There should only be 1 tag recorded for "bar"'

    # when five tags are saved...
    @article.tags = test_tags
    @article.save
    assert Tag.count == test_tags.length, 'Five tags should exist'
    test_tags.each do |tag|
      t = Tag.find_by_tag(tag)
      assert t[:volume] == 1, 'There should only be 1 tag recorded for "#{t[:tag]}"'
    end

    # when three "random" tags are removed and the article is saved...
    @article.tags = test_tags[2..3]
    @article.save
    assert Tag.count == 5, 'Five tags should still exist after deleting the other three.'
    test_tags.each do |tag|
      t = Tag.find_by_tag(tag)
      b = @article.tags.include?(tag)
      assert (b && t[:volume] == 1) || t[:volume] == 0,
          'There should be ' << (b ? '1' : '0') << ' tags recorded for "#{t[:tag]}"'
    end

    # when all tags are removed and the article is saved...
    @article.tags = nil
    @article.save
    assert Tag.count == 5, 'Five tags should still exist after deleting all tags from article.'
    test_tags.each do |tag|
      t = Tag.find_by_tag(tag)
      assert t[:volume] == 0, 'There should be 0 tags recorded for "#{t[:tag]}" after removed from article'
    end
  end


  test 'Testing tag saving on articles, part 3: database tags triggers, multiple entries' do
    @article.title = 'Valid title'
    @article.body = 'This is a valid body.'
    @article.user = @user
    @article.tags = ['mlem', 'derp', 'foo', 'bar']
    @article.save
    assert Tag.count == 4, 'There should be four tags after inserting them. ' << Tag.count << ' found instead.'

    @article2 = Article.create(title: 'Number 2', body: 'This body will pass tests.', user: @user,
                            tags: ['foo', 'bar'])
    @article3 = Article.create(title: 'Number 3', body: 'This body will pass tests.', user: @user,
                            tags: ['bar'])

    Tag.all.each do |tag|
      assert tag[:volume] == 1, 'Updated volume for wrong tag ' << tag[:tag] if tag[:tag] == 'mlem' || tag[:tag] == 'derp'
      assert tag[:volume] == 2, 'Did not update volume for ' << tag[:tag] if tag[:tag] == 'foo'
      assert tag[:volume] == 3, 'Did not update volume for ' << tag[:tag] if tag[:tag] == 'bar'
    end

    @article2.tags = ['bar']
    @article2.save
    Tag.all.each do |tag|
      assert tag[:volume] == 1, 'Updated volume for wrong tag ' << tag[:tag] if tag[:tag] == 'mlem' || tag[:tag] == 'derp'
      assert tag[:volume] == 1, 'Did not update volume for ' << tag[:tag] if tag[:tag] == 'foo'
      assert tag[:volume] == 3, 'Did not update volume for ' << tag[:tag] if tag[:tag] == 'bar'
    end

    @article.tags = ['derp', 'foo', 'bar']
    @article.save
    Tag.all.each do |tag|
      assert tag[:volume] == 0, 'Updated volume for wrong tag ' << tag[:tag] if tag[:tag] == 'mlem'
      assert tag[:volume] == 1, 'Updated volume for wrong tag ' << tag[:tag] if tag[:tag] == 'derp'
      assert tag[:volume] == 1, 'Updated volume for wrong tag ' << tag[:tag] if tag[:tag] == 'foo'
      assert tag[:volume] == 3, 'Did not update volume for ' << tag[:tag] if tag[:tag] == 'bar'
      assert ['mlem', 'derp', 'foo', 'bar'].include?(tag[:tag]), 'Unexpected tag found: ' << tag[:tag]
    end

    # Test the trigger to prevent deleting Tags associated with articles
    assert_difference 'Tag.count', -1, 'A tag with a volume of 0 can be deleted.' do
      Tag.find('mlem').destroy
    end

    assert_no_difference  'Tag.count', 'A tag with a volume greater than 0 cannot be deleted' do
      Tag.find('derp').destroy
    end
  end
end
