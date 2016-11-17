# == Schema Information
#
# Table name: trackers
#
#  id                    :integer          not null, primary key
#  name                  :string           not null
#  url                   :string           not null
#  link_format           :string
#  remove_from_name      :string
#  public                :boolean          default(FALSE), not null
#  domain                :boolean          default(FALSE), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  remove_from_string_id :string
#

class Tracker < ActiveRecord::Base
  default_scope { order('lower(name)') }
end
