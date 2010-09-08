require 'digest/sha1'

class User < ActiveRecord::Base

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # For role-requirement
  has_and_belongs_to_many :roles
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :old_password

  # For edit-profile requests  
  attr_accessor :old_password
  validates_presence_of :old_password, :if => :old_password_required?
  after_save :clear_password_fields

  #validates_each :old_password, :if => :old_password_required? do |user, attr, old_password|
  validate :if => :old_password_required? do |user|
    if !user.authenticated?(user.old_password)
      user.errors.add(:old_password, 'is incorrect')
      false
    else
      true
    end
  end
  
  def old_password_required?
    return false if crypted_password.blank?
    return false if self.new_record?
    return true if !password.blank?
    !User.attr_accessible.intersection(self.changed).empty?
  end

  def clear_password_fields
    password = password_confirmation = old_password = nil
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end

  protected
  
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end
  
end
