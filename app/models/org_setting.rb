# == Schema Information
#
# Table name: org_settings
#
#  id              :integer          not null, primary key
#  tracker_id      :integer          default(1)
#  organization_id :integer          not null
#  default_role    :string           default("read")
#  autoadd         :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  tracker_domain  :string
#

class OrgSetting < ActiveRecord::Base
  belongs_to :organization
  belongs_to :tracker
end
