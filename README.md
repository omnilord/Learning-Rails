Welcome to the Stock tracking app as defined by '''The Complete Ruby on Rails developer Course'''
available at [Udemy](https://www.udemy.com/the-complete-ruby-on-rails-developer-course).

This app supports using a gem to discover stock prices electronically in as near to real-time
as is allowed by law, uses the Devise gem for user management (a part of the project is to
customize Devise assets), and performs several other features that may or may not actually
be useful in a real application (you probably wouldn't want to follow your friends stocks,
since that has some questionable legality and cybersecurity considerations).

Please enjoy my code while I learn more about Ruby on Rails.  Thanks for reviewing!


## Deviations
This implementation deviates from the Udemy lessons by including and implementing a two-factor
authentication gem for [Twilio Authy](https://www.authy.com/).

In addition to using Authy, I have also switched to using Redis for sessions just to see how that
works.

This project also utilizes Handlebars.js in place of server-side partials for templated client-side
UI rendering of resources that are loaded via AJAX.
