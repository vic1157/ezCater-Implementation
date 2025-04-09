# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
	# This line is crucial - it disables the auto-generation of input types
    #input_object_class nil

	# Custom input object class:
    input_object_class Types::BaseInputObject
	
    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject
  end
end
