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

end
