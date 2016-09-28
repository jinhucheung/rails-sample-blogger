require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @aUser=User.new(name:"aUser",email:"aUser@example.com",
                   password:"helloAUser",password_confirmation:"helloAUser"
                   )
  end


  test "should be valid" do 
    assert @aUser.valid?
  end

  ##
  test "name should be presence" do 
    @aUser.name="  "
    assert_not @aUser.valid?
  end

  test "email should be presence" do 
    @aUser.email=""
    assert_not @aUser.valid?
  end

  test "password should be presence" do 
    @aUser.password=@aUser.password_confirmation="  "
    assert_not @aUser.valid?
  end

  ##
  test "name should not be too long" do 
    @aUser.name="a"*51
    assert_not @aUser.valid?
  end

  test "email should not be too long" do 
    @aUser.email="a"*244+"@example.com"
    assert_not @aUser.valid?
  end

  test "password should have a minimun length" do 
    @aUser.password=@aUser.password_confirmation="a"*5
    assert_not @aUser.valid?
  end

  ##
  test "email validation should accept valid addresses" do 
    valid_addresses=%w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @aUser.email=address 
      assert @aUser.valid? 
    end
  end

  test "email validation should reject invalid addresses" do 
    invalid_addressed=%w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addressed.each do |address|
      @aUser.email=address 
      assert_not @aUser.valid?
    end
  end

  ## 
  test "email addresses should be unique" do 
    dup_user=@aUser.dup
    dup_user.email.upcase!
    @aUser.save
    assert_not dup_user.valid?
  end

  ##
  test "email addressed should be saved as lower-case" do 
    test_email="Foo@EXAMPle.com"
    @aUser.email=test_email
    @aUser.save 
    assert_equal test_email.downcase,@aUser.reload.email
  end

  ## 
  test "authenticated? should return false for a user with nil diget" do 
    assert_not @aUser.authenticated?(:remember,'')
  end

  test "associated microposts should be destroyed" do 
    @aUser.save 
    @aUser.microposts.create!(content:"Hello World")
    assert_difference 'Micropost.count', -1 do 
      @aUser.destroy
    end
  end

  test "should follow and unfollow a user" do 
    user1=users(:user_4)
    user2=users(:user_5)
    assert_not user1.following?(user2)
    user1.follow(user2)
    assert user1.following?(user2)
    assert user2.followers.include?(user1)
    user1.unfollow(user2)
    assert_not user1.following?(user2)
  end
  
  test "feed should have the right posts" do 
    user1=users(:test_user)
    user2=users(:test_user2)
    user3=users(:user_6) 
    # 关注的用户发布的微博 
    user2.microposts.each do |post_following|
      assert user1.feed.include?(post_following)
    end
    # 自己的微博 
    user1.microposts.each do |post_self|
      assert user1.feed.include?(post_self)
    end
    # 未关注用户的微博 
    user3.microposts.each do |post_unfollowed|
      assert user1.feed.include?(post_unfollowed)
    end
  end

end
