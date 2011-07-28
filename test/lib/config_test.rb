require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "LIB: Cfg" do
  context "definition" do
    setup do
      Cfg['foo'] = { "alpha" => "Alpha", "beta" => "Beta" }
    end

    asserts("that Cfg['foo'] can be retrieved") { ! Cfg['foo'].nil? }
    asserts("that Cfg['foo'] has alpha and beta keys") { (Cfg['foo']['alpha'] == "Alpha") and (Cfg['foo']['beta'] == "Beta" ) }

    asserts("that a new value can be inserted via Cfg[]") { Cfg['key']= 'value' }
  end

  context "various methods" do
    asserts("Cfg.locale should be defined") { Cfg.respond_to? :locale }
    asserts("Cfg.locale should return 'it'") { Cfg.locale == "it" }

    asserts("Cfg.default_locale should be defined") { Cfg.respond_to? :default_locale }

    asserts("Cfg.acl should be defined") { Cfg.respond_to? :acl }

    asserts("Cfg.roles should be defined") { Cfg.respond_to? :roles }
  end

  context "insertions" do
    setup { Cfg.insert("foo".to_s, "bar") }
    asserts('Cfg inserts crap inside the database') {
      MongoMapper.database['configurations'].find({ _id: "foo" }).first['val'] == Cfg['foo'] }
  end
end
