module MongoMachete
  module Taggable
    extend ActiveSupport::Concern
    module ClassMethods
      def tag_cloud
        TagCloud.build self.collection
      end
      def tagging
        begin
          TagCloud.build(self.collection).collect{|t| t['_id']}
        rescue Exception => e
          puts "ERROR: #{ e } (#{ e.class })!"
          []
        end
      end
    end
    module InstanceMethods
      def tag_list
        (self['tags'].nil?)? '' : self['tags'].join(',')
      end
      def tag_list=(string)
        self['tags'] = []
        string.to_s.split(',').map { |n|
          n.gsub(/[^\w\s_-]/i, '').strip
        }.uniq.sort.each{ |o|
          self['tags'] << o
        }
      end
    end

    def self.configure(model)
      model.key :tags, Array
      model.scope :by_tag, lambda { |tag| where(:tags.in => tag) }
    end

  end
end

class TagCloud
  def self.map
    %q{function(){ this.tags.forEach(function(tag) { emit(tag, 1); });}}
  end
  def self.reduce
    %q{function(prev,current) { var count = 0; for(index in current){ count += current[index]; } return count; }}
  end

  def self.build(kollection)
    kollection.map_reduce(map, reduce, {:out => "tagcloud"})
    MongoMapper.database.collection('tagcloud').find({}).to_a
  end

end
