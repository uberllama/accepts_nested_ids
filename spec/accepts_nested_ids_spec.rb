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

  describe 'accepts_nested_ids for has_many_through' do
    let(:record) { Project.new }
    let(:association_attr) { :included_users }
    let(:association_ids_attr) { :included_user_ids }
    let(:association_class_name) { "User" }

    it_behaves_like "a proper gentleman"
  end

end
