module AcceptsNestedIds

  # Simple object that contains information about a nested ID association
  #
  # @param attr [Symbol]       association attribute (ex: :documents)
  # @param ids_attr [String]   ids association attribute (ex: 'document_ids')
  # @param class_name [String] association class name (ex: 'Document')
  class NestedIdAssociation < Struct.new(:attr, :ids_attr, :class_name)
  end

end
