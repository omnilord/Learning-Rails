Welcome to the Blog app as defined by '''The Complete Ruby on Rails developer Course'''
available at [Udemy](https://www.udemy.com/the-complete-ruby-on-rails-developer-course).

The blog branch is the first application "Alpha Blog" that is used to introduce students
to Ruby on Rails.  Unlike the lessons which use SQLite3 in development, I use PostgreSQL in both development and production.

The reason for this is, I adapted my implemention to take advantage of certain PostgreSQL
features (arrays, JSON, etc.) that I enjoy working with.  You can see this feature with the migrations for the articles table, specifically the tags column.
