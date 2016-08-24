module ApplicationHelper
  def avatar_for(user, opts = { size: 32 })
    #id = Digest::MD5::hexdigest(user.email.downcase)
    #url = "https://secure.gravatar.com/avatar/#{id}?s=#{opts[:size]}"
    img = (File.file?("#{Rails.root}/app/assets/images/users/{user.id}/{user.avatar}") ?
          user.avatar :
          'privateerconsulting-logo.png')
    image_tag(img, alt: 'B', width: opts[:size], height: opts[:size])
  end
end
