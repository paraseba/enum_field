require File.dirname(__FILE__) + '/spec_helper.rb'

describe EnumField::EnumeratedAttribute do
  class Role
    define_enum do |b|
      b.member :admin
      b.member :supervisor
      b.member :manager
    end
  end

  class User < ActiveRecord::Base
    has_many_enumerated_attributes :roles
  end

  class UserRole < ActiveRecord::Base
    set_table_name :users_roles
    belongs_to :user
    enumerated_attribute :role
  end

  class Person < ActiveRecord::Base
  end

  class PersonRole < ActiveRecord::Base
    set_table_name :people_roles
    belongs_to :person
    enumerated_attribute :role
  end

  context "with AR objects" do

    before(:each) {
      User.stub!(:columns).and_return([])
      User.class_eval('attr_accessor :user_roles')
      Person.stub!(:columns).and_return([])
      UserRole.stub!(:columns).and_return([ ActiveRecord::ConnectionAdapters::Column.new(:role_id, nil),
                                            ActiveRecord::ConnectionAdapters::Column.new(:user_id, nil)])
      PersonRole.stub!(:columns).and_return([ ActiveRecord::ConnectionAdapters::Column.new(:role_id, nil),
                                              ActiveRecord::ConnectionAdapters::Column.new(:person_id, nil)])
      @user = User.new
    }


    it "should add has_many_enumerated_attribute class method to ActiveRecord::Base" do
      ActiveRecord::Base.should respond_to(:has_many_enumerated_attributes)
    end

    it "should define reader on the field" do
      @user.should respond_to(:roles)
    end

    it "should define writter on the field" do
      @user.should respond_to(:'roles=')
    end

    it "should define has many person_roles" do
      Person.should_receive(:has_many) # .with(:person_roles, {:class_name => 'PersonRole'})
      Person.has_many_enumerated_attributes :roles
    end

    it "should assign field ids when fields is assigned" do
      @user.roles = [Role.admin]
      @user.role_ids.first.should == Role.admin.id
    end

    it "should return fields after field_ids is assigned" do
      @user.role_ids = [Role.admin.id]
      @user.roles.first.should == Role.admin
    end

    it "should return empty fields for not field_ids" do
      @user.role_ids = []
      @user.roles.should be_empty
    end

    it "should return empty field ids for empty fields" do
      @user.roles = []
      @user.role_ids.should be_empty
    end

    it "should include the roles asigned" do
      @user.roles = [Role.admin, Role.manager]
      @user.roles.should include(Role.admin)
      @user.roles.should include(Role.manager)
    end

    it "should not include unassigned roles" do
      @user.roles = [Role.admin, Role.manager]
      @user.roles.should_not include(Role.supervisor)
    end
  end
end
