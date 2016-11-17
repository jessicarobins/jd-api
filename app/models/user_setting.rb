# == Schema Information
#
# Table name: user_settings
#
#  id             :integer          not null, primary key
#  menu_favorites :string           default([]), is an Array
#  user_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  show_intro     :boolean          default(TRUE)
#

class UserSetting < ActiveRecord::Base
  belongs_to :user
end
