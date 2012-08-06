class PostMailer < ActionMailer::Base
  default :from => "thebrain@piupiu.at"

  def new_comment(post, recipient)
    @post = post
 	mail :to => recipient, :subject => "Your post has been commented"
  end

  def acknowledge_report(recipient)
 	mail :to => recipient, :subject => "You reported a post at piupiu.at"
  end

  def report_post(post, sender)
    @post = post
 	mail :from => sender, :to => "mimimi@piupiu.at", :subject => "Post #{post.id} marked as inappropriate"
  end
end
