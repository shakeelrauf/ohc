# frozen_string_literal: true

class BaseDecorator
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_accessor :object, :context

  delegate :current_user, to: :@context
  delegate :to_param, to: :object
  delegate_missing_to :object

  def initialize(object, context = {})
    @object = object
    @context = context
  end

  class << self
    def decorate(object, context = {})
      new(object, context)
    end

    def decorate_collection(collection, context = {})
      collection.map { |object| decorate(object, context) }
    end
  end
end
