module ApplicationHelper
  def avatar_for(user, opts = { size: 32 })
    #id = Digest::MD5::hexdigest(user.email.downcase)
    #url = "https://secure.gravatar.com/avatar/#{id}?s=#{opts[:size]}"
    image_tag('privateerconsulting-logo.png', alt: 'B', width: opts[:size], height: opts[:size])
  end
end
