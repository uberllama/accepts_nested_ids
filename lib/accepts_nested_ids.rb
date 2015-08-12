require "accepts_nested_ids/version"
require "accepts_nested_ids/nested_id_association"
require "active_support/concern"
require "active_support/core_ext/string/inflections"

# Allows a model to accept nested association IDs as an attribute.
# Normally these associations would be immediately saved, even if
# the parent model transaction failed. This class defers saving to
# after_save, and also provides dirty attribute tracking on the
# parent model.
#
module AcceptsNestedIds
  extend ActiveSupport::Concern

    included do
      after_save :save_nested_id_associations
    end

    # Defered association setter
    #
    # @example Method definition
    #   if @document_ids
    #     self.documents = Document.where(id: document_ids)
    #   end
    #
    def save_nested_id_associations
      nested_id_associations.each do |nested_id_association|
        if instance_variable_get("@#{nested_id_association.ids_attr}")
          association_class = nested_id_association.class_name.constantize
          ids               = send(nested_id_association.ids_attr)
          send("#{nested_id_association.attr}=", association_class.where(id: ids))
        end
      end
    end

    def nested_id_associations
      self.class.nested_id_associations || self.class.superclass.nested_id_associations
    end

    module ClassMethods

      # Sets up defered save and dirty tracking for the specified associations
      #
      # @example When class_name can be inferred from association name
      #   include AcceptsNestedIds
      #   accepts_nested_ids_for :documents, :users
      #
      # @example When class_name is different from association name
      #   include AcceptsNestedIds
      #   accepts_nested_ids_for :documents, included_users: "User"
      #
      # @param args [Array]
      def accepts_nested_ids_for(*args)
        @_nested_id_associations = map_nested_id_associations(*args)

        nested_id_associations.each do |nested_id_association|

          # Define ids_attr getter
          #
          # @example Method definition
          #   def document_ids
          #     @document_ids || (documents.loaded? ? documents.map(&:id) : documents.pluck(:id))
          #   end
          #
          define_method("#{nested_id_association.ids_attr}") do
            association = send(nested_id_association.attr)
            instance_variable_get("@#{nested_id_association.ids_attr}") ||
              (association.loaded? ? association.map(&:id) : association.pluck(:id))
          end

          # Define ids_attr setter
          #
          # @example Method definition
          #   def document_ids=(value)
          #     return if document_ids == value
          #     attribute_will_change!('document_ids')
          #     @document_ids = value
          #   end
          #
          define_method("#{nested_id_association.ids_attr}=") do |value|
            return if send(nested_id_association.ids_attr) == value
            attribute_will_change!(nested_id_association.ids_attr)
            instance_variable_set("@#{nested_id_association.ids_attr}", value)
          end

        end
      end

      def nested_id_associations
        @_nested_id_associations
      end

      private

      # Map module args into array of NestedIdAssociation objects with supporting properties
      #
      # @example
      #   accepts_nested_ids_for :documents, included_users: "User"
      #   =>
      #   [
      #     { attr: :documents:, ids_attr: "document_ids", class_name: "Document"},
      #     { attr: :included_users, ids_attr: "included_user_ids", class_name: "User" }
      #   ]
      #
      # @param args [Array]
      # @return [Array]
      def map_nested_id_associations(*args)
        args.inject([]) do |array, arg|
          if arg.is_a?(Hash)
            attr        = arg.keys.first
            ids_attr    = get_ids_attr(attr)
            class_name  = arg[attr]
          else
            attr        = arg
            ids_attr    = get_ids_attr(attr)
            class_name  = arg.to_s.classify
          end
          array << NestedIdAssociation.new(attr, ids_attr, class_name)
          array
        end
      end

      # @example
      #   get_ids_attr(:documents) => "document_ids"
      #
      # @param attr [Symbol] Association attribute name
      # @return [String]
      def get_ids_attr(attr)
        "#{attr.to_s.singularize}_ids"
      end

    end
end
