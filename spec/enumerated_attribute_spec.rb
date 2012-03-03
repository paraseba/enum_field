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
    enumerated_attribute :role
  end


  before(:all) {
    ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ':memory:'
    ActiveRecord::Base.connection.create_table(:users) do |t|
      t.belongs_to :role
    end
  }

  it "should add enumerated_attribute class method to ActiveRecord::Base" do
    ActiveRecord::Base.should respond_to(:enumerated_attribute)
  end

  context "with AR objects" do

    before(:each) {@user = User.new}

    it "should define reader on the field" do
      @user.should respond_to(:role)
    end

    it "should define writter on the field" do
      @user.should respond_to(:'role=')
    end

    it "should assign field id when field is assigned" do
      @user.role = Role.admin
      @user.role_id.should == Role.admin.id
    end

    it "should return field after field_id is assigned" do
      @user.role_id = Role.admin.id
      @user.role.should == Role.admin
    end

    it "should return nil field for nil field id" do
      @user.role.should be_nil
    end

    it "should return nil field id for nilled field" do
      @user.role_id = Role.admin.id
      @user.role = nil
      @user.role_id.should be_nil
    end

    it "should return nil field for nilled field id" do
      @user.role = Role.admin
      @user.role_id = nil
      @user.role.should be_nil
    end
  end
end

