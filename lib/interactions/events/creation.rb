# frozen_string_literal: true

module Interactions
  module Events
    class Creation < BaseInteractions::Creation
      def perform_interaction!
        cc_group = Cometchat::Group.create(guid: self.class.generate_uid(@object.name),
                                           name: @object.name,
                                           type: 'public')

        @object.update(chat_guid: cc_group.guid, skip_chat_attribute_validation: false)
      end
    end
  end
end
