class PostMailer < ActionMailer::Base
  default :from => "thebrain@piupiu.at"

  def new_comment(post, recipient)
    @post = post
 	mail :to => recipient, :subject => "Your post has been commented"
  end
end
