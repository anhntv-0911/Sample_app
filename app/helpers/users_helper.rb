module UsersHelper
  def gravatar_for user, size: Settings.gravatar.size
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def active_build
    current_user.active_relationships.build
  end

  def active_find user_id
    current_user.active_relationships.find_by followed_id: user_id
  end
end
