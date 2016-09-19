module ApplicationHelper
  
  def full_title(head='')
   tail="Ruby on Rails Tutorial Sample App"
   return  tail if head.blank?
   return  "#{head} | #{tail}" 
  end 

end
