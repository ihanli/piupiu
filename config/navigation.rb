SimpleNavigation::Configuration.run do |navigation|  
  navigation.items do |primary|
    primary.item :profile, image_tag(Proc.new{ current_user.avatar.url(:icon) }.call), user_root_path, :class => "rahmen_profilbild", :if => Proc.new{ user_signed_in? }
    primary.item :posts, "", posts_path, :class => "overview_link", :if => Proc.new{ user_signed_in? }
    primary.item :new_post, "", new_post_path, :class => "new_post", :if => Proc.new{ user_signed_in? }
    primary.item :logout, "", destroy_user_session_path, :class => "logout", :if => Proc.new{ user_signed_in? }
    primary.item :wtf, "", page_path("wtf"), :class => "wtf"
    primary.item :impressum, "", page_path("impressum"), :class => "impressum"
  end
end