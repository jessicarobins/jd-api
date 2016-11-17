# == Schema Information
#
# Table name: tickets
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string           not null
#  spec_id       :integer          not null
#  string_id     :string
#  deleted_at    :time
#  deleted_by_id :integer
#  tracker_id    :integer          default(1), not null
#

class Ticket < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :spec
  belongs_to :tracker

  before_create :add_ids

  validates_presence_of :spec_id
  validates_presence_of :tracker_id
  validates_presence_of :name

  validates_as_paranoid
  validates_uniqueness_of_without_deleted :name, :scope => :spec_id

  def url
    tracker_url = self.tracker.url
    if self.tracker.domain
      domain = self.spec.project.organization.org_setting.tracker_domain
      tracker_url.sub!('#', domain)
    end
    tracker_url + self.string_id
  end

  def self.add_from_array(spec_id:, tickets:, tracker_id:)
    tickets.each do |ticket|
      Ticket.create!(
        :spec_id => spec_id,
        :name => ticket,
        :tracker_id => tracker_id)
    end
  end

  private

  def add_ids
    add_tracker_id
    format_strings
  end

  def add_tracker_id
    self.tracker_id = self.spec.project.organization.org_setting.tracker_id
  end

  def format_strings
    string_id = self.name.strip
    name = string_id

    if self.tracker.remove_from_name
      regex = Regexp.new self.tracker.remove_from_name
      name = name.sub regex, ''
    end
    self.name = name

    if self.tracker.remove_from_string_id
      regex = Regexp.new self.tracker.remove_from_string_id
      string_id = string_id.sub regex, ''
    end
    self.string_id = string_id
  end
end
