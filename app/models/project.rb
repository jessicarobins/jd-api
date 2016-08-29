class Project < ActiveRecord::Base
    has_many :specs, dependent: :destroy
    belongs_to :created_by, class_name: "User"
    belongs_to :organization
    
    validates_presence_of :name
    validates_presence_of :organization_id
    
    default_scope { order('lower(name)') }
    scope :for_user, -> (user) { where(:created_by => user) }
    scope :for_org, -> (org_id) { where(:organization_id => org_id) }
    
    def self.create_default_project(org_id:, created_by_id:)
        project = Project.create!(
            :name => 'Demo Project', 
            :organization_id => org_id,
            :created_by_id => created_by_id)
        
        Spec.create_default_specs(
            :project_id => project.id,
            :created_by_id => created_by_id)
    end
end