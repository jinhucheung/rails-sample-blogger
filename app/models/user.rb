class User < ApplicationRecord
  before_save {email.downcase! }
  before_create :create_activation_digest

  validates :name , presence: true , length:{ maximum:50 }

  VALID_EMAIL_REGEX=/\A[\w\+\-\.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true , length:{ maximum:255 } , 
                    format: { with: VALID_EMAIL_REGEX } ,
                    uniqueness: { case_sensitive: false  }

  has_secure_password
  validates :password,presence:true,length:{ minimum:6 },allow_nil:true

  # 记忆令牌,激活令牌
  attr_accessor :remember_token,:activation_token

  # 返回指定密码字符串的哈希
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                 BCrypt::Engine.cost
    BCrypt::Password.create(string,cost: cost)
  end

  # 生成记忆令牌
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 保存记忆令牌摘要至数据库
  def remember
    self.remember_token=User.new_token
    update_attribute(:remember_digest,User.digest(remember_token))
  end

  def authenticated?(attribute,token)
    digest=send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token) 
  end
  
  def forget
    update_attribute(:remember_digest,nil)
  end

  # 创建并赋值激活令牌和摘要
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest= User.digest(activation_token)
  end

  # 激活用户
  def activate 
    update_columns(activated:true,activated_at:Time.zone.now)
  end

  # 发送激活邮件
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

end
