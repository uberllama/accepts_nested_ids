require 'spec_helper'

describe AcceptsNestedIds do

  it 'has a version number' do
    expect(AcceptsNestedIds::VERSION).not_to be nil
  end

  describe 'accepts_nested_ids for has_many' do
    let(:record) { Project.new }
    let(:association_attr) { :documents }
    let(:association_ids_attr) { :document_ids }
    let(:association_class_name) { "Document" }

    it_behaves_like "a proper gentleman"
  end

  describe 'accepts_nested_ids for has_many_through with alternate association name' do
    let(:record) { Project.new }
    let(:association_attr) { :included_users }
    let(:association_ids_attr) { :included_user_ids }
    let(:association_class_name) { "User" }

    it_behaves_like "a proper gentleman"
  end

  describe 'accepts_nested_ids for associations defined by a base class' do
    let(:record) { Company.new }
    let(:association_attr) { :users }
    let(:association_ids_attr) { :user_ids }
    let(:association_class_name) { "User" }

    it_behaves_like "a proper gentleman"
  end

  describe 'accepts_nested_ids for associations defined in a subclass' do
    let(:record) { Vendor.new }
    let(:association_attr) { :rental_services }
    let(:association_ids_attr) { :rental_service_ids }
    let(:association_class_name) { "RentalService" }

    it_behaves_like "a proper gentleman"
  end

  describe 'accepts_nested_ids for associations defined in the base class of a subclass' do
    let(:record) { Vendor.new }
    let(:association_attr) { :users }
    let(:association_ids_attr) { :user_ids }
    let(:association_class_name) { "User" }

    it_behaves_like "a proper gentleman"
  end

end
