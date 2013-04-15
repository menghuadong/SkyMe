class User < ActiveRecord::Base
  #对应数据库中的部分可以通过表单进行修改的属性值，massassignment
  attr_accessible :email, :name,:password, :password_confirmation

  #实现各个数据模型之间的关系，比如一对多 多对多等
  has_many:microposts,:dependent=>:destroy
  has_many:relationships,:foreign_key=>"follower_id",:dependent=>:destroy
  has_many :followed_users, :through=> :relationships, :source=> :followed
  
  has_many :reverse_relationships, :foreign_key=> "followed_id",
           :class_name=> "Relationship",
           :dependent=> :destroy
  has_many :followers, :through=> :reverse_relationships, :source=> :follower  
  
  #回调函数
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  has_secure_password
  
  #常见的验证方式，比如存在行 唯一性 长度限制 不能为空 类似与SQL中对相关属性的制   约条件
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates:name,:presence => true,
	   :length =>{:maximum=>50}
  validates:email,:presence => true,
           :format=>{:with=>VALID_EMAIL_REGEX},
           :uniqueness=> { :case_sensitive=> false }
  validates :password, :presence=> true, :length=> { :minimum=> 6 }
  validates :password_confirmation, :presence=> true
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  #！表示会抛出异常
  def follow!(other_user)
    relationships.create!(:followed_id=> other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private
    #注意关键字self，如果没有就只是一个变量 而不是User的一个类属性了
    def create_remember_token
      self.remember_token = SecureRandom.hex
    end
end
