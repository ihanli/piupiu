namespace :asset do
  desc "Copy assets from [SOURCE] to local machine (replaces system folder). SOURCE is staging by default."
  task :copy_assets do
    if ENV["SOURCE"] == "production"
      sh "scp -r root@piupiu.at:/var/www/virtualhosts/piupiu.at/shared/system/ /d/FHS/piupiu/public/"
    else
      sh "scp -r root@piupiu.at:/var/www/virtualhosts/beta.piupiu.at/shared/system/ /d/FHS/piupiu/public/"
    end
  end
end