# frozen_string_literal: true

module Interactions
  module Users
    class Creation < BaseInteractions::Creation
      def perform_interaction!
        cc_user = Cometchat::User.create(uid: self.class.generate_uid(@object.full_name),
                                         name: @object.full_name,
                                         role: @object.child? ? 'child' : 'admin')

        if @object.update(chat_uid: cc_user.uid, chat_auth_token: cc_user.auth_token, skip_chat_attribute_validation: false)
          @object.attendances.each do |attendance|
            Interactions::Attendances::Creation.new(attendance).execute
          end
        end

        @object
      end
    end
  end
end
