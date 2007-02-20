# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  
  protected
  
  def random_image
    image_files = %w( .jpg .gif .png )
    files = Dir.entries(
          "#{RAILS_ROOT}/public/headers" 
      ).delete_if { |x| !image_files.index(x[-4,4]) }
    files[rand(files.length)]
  end

  def page_title
    if @topic && (current_action != "new")
      @topic.title + " (" + SITE_TITLE + ")"
    elsif @user && (current_action != "new") && logged_in?
      @user.login + " (" + SITE_TITLE + ")"
    else
      SITE_TITLE
    end
  end
  
  def newbie
    @newbie = Newbie.find(:first, :order => "RAND()")
    return "Newest User" if @newbie.nil?
    return @newbie.term
  end
  
  def avatar_img(user)
    image_tag AVATARS_PATH + h(user.avatar) unless user.avatar.blank?
  end
  
  def rank_for(posts_count)
    @rank = Ranks.find(:first, :conditions => "#{posts_count} >= min_posts", :order => "min_posts desc")
    return "Member" if @rank.nil?
    return @rank.title
  end
  
  def tab(name)
    if name == current_controller
      'tab'
    elsif name == "topics" && (current_controller == "posts")
      'tab'
    end
  end
  
  def current_controller
    request.path_parameters['controller']
  end
  
  def current_action
    request.path_parameters['action']
  end
    
end
