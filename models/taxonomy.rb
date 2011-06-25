class Taxonomy
  include MongoMapper::Document
  plugin MongoMapper::Plugins::HashParameterAttributes

  key :slug, Translation
  key :title, Translation

  key :parent_id, String
  key :path, Translation
  key :path_id, String, :default => '' # used for the real tree implementation
  key :depth, Integer, :default => 0

  key :description, Translation

  # TODO: implement this!
  key :weight, Integer, :default => 1


  embeds :slug, :path

  validates_presence_of :title, :description
  validates_uniqueness_of :title, :slug

  def parent
    (self.parent_id != '' )? find(self.parent_id) : nil
  end

  def self.by_path(path)
    where(:"path.#{Cfg.locale}" => %r{#{path}} ).first
  end

  def self.threaded(path='', json = false)
    taxons = where({ :path_id => %r{#{path}} }).order("path asc, weight desc")
    results, map  = [], {}
    taxons.each do |taxon|
      if taxon.parent_id.blank?
        results << taxon
      else
        taxon.path_id =~ /:([\d|\w]+)$/
        if parent = $1
          map[parent] ||= []
          map[parent] << taxon
        end
      end
    end
    if json
      assemble_json(results, map)
    else
      assemble(results, map)
    end
  end

  # Used by Taxonomy#threaded to assemble the results.
  def self.assemble(results, map)
    list = []
    results.each do |result|
      if map[result.id.to_s]
        list << result
        list << assemble(map[result.id.to_s], map)
      else
        list << result
      end
    end
    list
  end
  def self.assemble_json(results, map)
    list = {}
    results.each do |result|
      o ={result.title.to_s => {"---" => result.id.to_s}}
      o[result.title.to_s].merge!(assemble_json(map[result.id.to_s], map)) if map[result.id.to_s]
      list.merge! o
    end
    list
  end

  before_save :set_path
  private
  # Store the taxon's path.
  def set_path
    if self['parent_id'].blank?
      self['path_id'] = ''
      Cfg[:locales].each{|l|
        self['path'][l] = self['slug'][l]
      }
    else
      parent = Taxonomy.find(self['parent_id'])
      self['depth']   = parent.depth + 1
      self['path_id'] = parent.path_id + ":" + parent.id.to_s
      Cfg[:locales].each{|l|
        self['path'][l] = parent.path[l] + "/" + self['slug'][l]
      }
    end
    #save
  end
end

