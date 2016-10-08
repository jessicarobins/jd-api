def load_from_file(filename:, project:)
    file = File.read(filename)
    data_hash = eval(file)
    
    created_by_id = User.find_by!(:email => 'jessdocs3@gmail.com').id
    org = project.organization
    
    tracker = Tracker.find_by!(:name => 'Pivotal')
    ActiveRecord::Base.transaction do
        add_specs(
            :specs => data_hash, 
            :project_id => project.id,
            :tracker => tracker,
            :created_by_id => created_by_id,
            :org => org)
    end
end

def add_specs(specs:, parent:nil, tracker:, project_id:, created_by_id:, org:)
    specs = specs || []
    specs.each do |spec|
        add_spec(
            :spec_hash => spec, 
            :project_id => project_id,
            :created_by_id => created_by_id,
            :parent => parent, 
            :tracker => tracker,
            :org => org)
    end
end

def add_spec(spec_hash:, parent: nil, tracker:, project_id:, created_by_id:, org:)
    spec = Spec.create!(
        :created_by_id => created_by_id,
        :updated_by_id => created_by_id,
        :description => spec_hash["description"],
        :bookmarked => spec_hash["bookmarked"],
        :project_id => project_id)
        
    add_tags(
        :spec => spec, 
        :tags => spec_hash["tags"], 
        :created_by_id => created_by_id,
        :org => org)
    add_tickets(:spec => spec, :tickets => spec_hash["tickets"], :tracker => tracker)
    
    spec.parent = parent
    spec.save!
    
    add_specs(
        :specs => spec_hash[:children],
        :parent => spec,
        :tracker => tracker,
        :project_id => project_id,
        :created_by_id => created_by_id,
        :org => org)
end

def add_tags(spec:, tags:, created_by_id:, org:)
    tags = tags || []
    tags.each do |tag|
        tag_type_name = tag["tag_type"]["name"]
        tag_type = TagType.find_by(:name => tag_type_name)
        unless tag_type
            tag_type = TagType.create!(
                :created_by_id => created_by_id,
                :name => tag_type_name,
                :color => tag["tag_type"]["color"],
                :organization_id => org.id)
        end
    
       Tag.create!(
           :tag_type_id => tag_type.id,
           :spec_id => spec.id) 
    end
end

def add_tickets(spec:, tickets:, tracker:)
    tickets = tickets || []
    tickets.each do |ticket|
        #name, tracker_id
        Ticket.create!(
            :name => ticket["name"],
            :string_id => ticket["tracker_id"],
            :spec_id => spec.id,
            :tracker_id => tracker.id)
    end
end