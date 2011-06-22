require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

context "LIB: Cfg" do
  setup { Configuration.delete_all }

  context "definition" do
    setup do
      Configuration.new({ _id: 'foo',
                          val: '{ "alpha": "Alpha", "beta": "Beta" }'
      }).save
    end

    asserts("that Cfg['foo'] can be retrieved") { ! Cfg['foo'].nil? }
    asserts("that Cfg['foo'] has alpha and beta keys") { (Cfg['foo']['alpha'] == "Alpha") and (Cfg['foo']['beta'] == "Beta" ) }

    asserts("that a models inserts the key and value in Cfg") { ! Cfg['bar'].nil? }
    asserts("that a new value can be inserted via Cfg[]") { Cfg['key']= 'value' }
  end

  context "hooks" do
    setup{Configuration.new({ _id: 'bar', val: '"foobar"'}).save}
    asserts("hook is executed") { ! Cfg['bar'].nil? }
  end
end
