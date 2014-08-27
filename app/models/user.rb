class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
 
  #added for username entry
  validates_uniqueness_of :username, :case_sensitive => false
  
  
  
  has_many :reviews
  has_many :votes
  
  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username' added for username login
  attr_accessor :login
  
  #added for username login
  def self.find_first_by_auth_conditions(warden_conditions)
  conditions = warden_conditions.dup
  if login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  else
    where(conditions).first
  end
end
  
  #If I need to use login later
  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

end
