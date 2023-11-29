# frozen_string_literal: true

module Interactions
  module Cabins
    class Creation < BaseInteractions::Creation
      def perform_interaction!
        cc_group = Cometchat::Group.create(guid: self.class.generate_uid(@object.name),
                                           name: "#{@object.camp.chat_guid}_#{@object.name}",
                                           type: 'private')

        @object.update(chat_guid: cc_group.guid, skip_chat_attribute_validation: false)
      end
    end
  end
end
