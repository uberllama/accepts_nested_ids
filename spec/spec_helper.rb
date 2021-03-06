$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'accepts_nested_ids'
require 'active_record'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :companies do |t|
    t.string :type, null: false
  end

  create_table :users do |t|
  end

  create_table :projects do |t|
  end

  create_table :project_users do |t|
    t.integer :project_id, null: false
    t.integer :user_id, null: false
  end

  create_table :documents do |t|
    t.integer :project_id, null: false
  end

  create_table :rental_services do |t|
    t.integer :vendor_id, null: false
  end
end

class Company < ActiveRecord::Base
  include AcceptsNestedIds
  has_many :users
  accepts_nested_ids_for :users
  attribute :user_ids
end

class Vendor < Company
  has_many :rental_services
  accepts_nested_ids_for :rental_services
  attribute :rental_service_ids
end

class User < ActiveRecord::Base
  has_many :project_users
  has_many :projects, through: :project_users
end

class Project < ActiveRecord::Base
  include AcceptsNestedIds
  has_many :documents
  has_many :project_users
  has_many :included_users, through: :project_users, source: :user
  accepts_nested_ids_for :documents, included_users: "User"
  attribute :document_ids
  attribute :included_user_ids
end

class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
end

class Document < ActiveRecord::Base
  belongs_to :project
end

class RentalService < ActiveRecord::Base
  belongs_to :vendor
end
