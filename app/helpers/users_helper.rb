module UsersHelper
  
  # 返回指定用户的Gravatar
  def gravatar_for(user,size:88)
    # 获取用户邮箱地址
    email_address=user.email.downcase
    # 创建MD5 hash 
    gravatar_hash=Digest::MD5::hexdigest(email_address)
    # gravatar图片URL
    gravatar_url="https://www.gravatar.com/avatar/#{gravatar_hash}?s=#{size}"
    # 返回img标签
    image_tag(gravatar_url,alt:user.name,class:"gravatar")
  end
end
