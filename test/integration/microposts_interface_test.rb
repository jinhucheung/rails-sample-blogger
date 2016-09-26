require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user=users(:test_user)
  end

  test "micropost interface" do 
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # 无效提交
    assert_no_difference 'Micropost.count' do 
      post microposts_path,params:{ micropost:{ content: "" }  }
    end 
    assert_select 'div[class=?]','error_explanation'
    # 有效提交 
    content="Hello World"
    picture=fixture_file_upload('test/fixtures/rails.png','image/png')
    assert_difference 'Micropost.count' do 
      post microposts_path,params:{ micropost:{ content: content,picture: picture } }
    end
    assert assigns(:micropost).picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content,response.body
    # 删除一篇博客
    assert_select 'a',text:'delete'
    first_micropost=@user.microposts.paginate(page:1).first
    assert_difference 'Micropost.count',-1 do 
      delete micropost_path(first_micropost)
    end
    # 访问另一个用户的资料页面 
    get user_path(users(:test_user2))
    assert_select 'a',text:'delete',count:0
  end


  test "micropost sidebar count" do 
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts",response.body
    # 这个用户没有发布微博 
    others=users(:user_1)
    log_in_as(others)
    get root_path 
    assert_match "0 microposts",response.body
    others.microposts.create!(content:"A micropost")
    get root_path
    assert_match "1 micropost",response.body
  end

end
