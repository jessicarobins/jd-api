# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  text       :string           not null
#  resolved   :boolean          default(FALSE), not null
#  user_id    :integer          not null
#  spec_id    :integer          not null
#  ancestry   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Comment < ActiveRecord::Base
  has_ancestry

  belongs_to :spec
  belongs_to :user

  validates_presence_of :spec_id
  validates_presence_of :user_id
  validates_presence_of :text

  default_scope { order(created_at: :asc) }
  scope :by_resolved, -> { all.group_by(&:resolved) }
  scope :open, -> { where(resolved: false) }
end
