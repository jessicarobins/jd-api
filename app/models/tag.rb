class Tag < ActiveRecord::Base
    acts_as_paranoid
    
    belongs_to :spec
    belongs_to :tag_type
    
    validates_presence_of :spec_id
    validates_presence_of :tag_type_id
    validates_as_paranoid
    validates_uniqueness_of_without_deleted :spec_id, :scope => :tag_type_id
    
    def name
        TagType.find(tag_type_id).name
    end
    
    def color
        TagType.find(tag_type_id).color
    end
    
    def self.mass_add(tags:, spec_id:)
        tag_text_array = tags.split("#")
        tag_text_array.shift
        rejected_tag_array = []
        
        tag_text_array.each do |tag_text|
            tag_text.squish!
            tag_type = TagType.find_by(:name => tag_text)
            if tag_type
                Tag.create!(
                    :tag_type_id => tag_type.id,
                    :spec_id => spec_id)
            else
                rejected_tag_array << tag_text
            end
        end
        
        rejected_tag_array
    end
    
end
