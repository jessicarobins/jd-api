# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  rolify
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  devise :omniauthable

  validates_uniqueness_of :email

  has_one :user_setting
  has_many :user_organizations
  has_many :organizations, through: :user_organizations

  before_create :set_up_user
  after_create :add_user_defaults

  def personal_org
    organizations.where(name: 'Personal').first
  end

  private

  def set_up_user
    # devise stuff
    skip_confirmation!
  end

  def add_user_defaults
    create_personal_org
    add_domain_org
    create_settings
  end

  def create_settings
    UserSetting.create!(user: self)
  end

  def create_personal_org
    org = Organization.create!(name: 'Personal')
    organizations << org

    add_role :write, org
  end

  def add_domain_org
    domain = email.split('@')
    org = Organization.find_by(domain: domain)
    if org
      organizations << org

      add_role :read, org
    end
  end
end
