# frozen_string_literal: true

module Interactions
  class MergeRelationships
    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def execute
      validate_params
      validate_not_identical
      validate_matching_classes

      @destination.class.transaction do
        has_many_relationships.each do |association, foreign_key|
          @source.send(association).update_all(foreign_key => @destination.id, updated_at: Time.zone.now)
        end

        @source.destroy!
      end

      @destination
    end

    private

    def validate_params
      raise MergeError, 'Source and destination must be present' unless @source.present? && @destination.present?
    end

    def validate_not_identical
      raise MergeError, 'Source and destination cannot be the same' if @source == @destination
    end

    def validate_matching_classes
      raise MergeError, 'Source and destination classes do not match' unless @source.class == @destination.class
    end

    def has_many_relationships
      relationships = @source.class.reflections.collect do |a, b|
        [a, b.foreign_key] if b.is_a?(ActiveRecord::Reflection::HasManyReflection)
      end

      relationships.compact
    end
  end

  class MergeError < StandardError; end
end
