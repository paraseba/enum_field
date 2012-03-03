require File.dirname(__FILE__) + '/spec_helper.rb'

describe EnumField::EnumeratedAttribute do
  class Role
    define_enum do |b|
      b.member :admin
      b.member :supervisor
      b.member :manager
    end
  end

  class Client < ActiveRecord::Base
    has_many_enumerated_attributes :roles
  end

  class ClientRole < ActiveRecord::Base
    belongs_to :client
    enumerated_attribute :role
  end

  class Person < ActiveRecord::Base
  end

  class PersonRole < ActiveRecord::Base
    belongs_to :person
    enumerated_attribute :role
  end

  context "with AR objects" do

    before(:all) {
      ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ':memory:'
      ActiveRecord::Base.connection.create_table(:clients)
      ActiveRecord::Base.connection.create_table(:people)
      ActiveRecord::Base.connection.create_table(:client_roles) do |t|
        t.belongs_to :client
        t.belongs_to :role
      end
      ActiveRecord::Base.connection.create_table(:person_roles) do |t|
        t.belongs_to :person
        t.belongs_to :role
      end
    }

    before(:each) {@client = Client.create}


    it "should add has_many_enumerated_attribute class method to ActiveRecord::Base" do
      ActiveRecord::Base.should respond_to(:has_many_enumerated_attributes)
    end

    it "should define reader on the field" do
      @client.should respond_to(:roles)
    end

    it "should define writter on the field" do
      @client.should respond_to(:'roles=')
    end

    it "should define has many person_roles" do
      Person.should_receive(:has_many) # .with(:person_roles, {:class_name => 'PersonRole'})
      Person.has_many_enumerated_attributes :roles
    end

    it "should assign field ids when fields is assigned" do
      @client.roles = [Role.admin]
      @client.role_ids.first.should == Role.admin.id
    end

    it "should return fields after field_ids is assigned" do
      @client.role_ids = [Role.admin.id]
      @client.roles.first.should == Role.admin
    end

    it "should return empty fields for not field_ids" do
      @client.role_ids = []
      @client.roles.should be_empty
    end

    it "should return empty field ids for empty fields" do
      @client.roles = []
      @client.role_ids.should be_empty
    end

    it "should include the roles asigned" do
      @client.roles = [Role.admin, Role.manager]
      @client.roles.should include(Role.admin)
      @client.roles.should include(Role.manager)
    end

    it "should not include unassigned roles" do
      @client.roles = [Role.admin, Role.manager]
      @client.roles.should_not include(Role.supervisor)
    end
  end
end
