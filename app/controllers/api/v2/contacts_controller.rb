# frozen_string_literal: true

module API
  module V2
    class ContactsController < BaseController
      # == [POST] /api/v2/contact.json
      # Send a contact us email
      # ==== Required
      # * text - the email body
      def create
        contact_email = current_user.contact_email_messages.build(allowed_params_with_tenant)

        if contact_email.save
          ContactUsMailer.contact_us(contact_email, current_user).deliver_later

          render json: API::V2::ContactEmailMessageSerializer.new(contact_email, serializer_params), status: :created
        else
          render_object_error object: contact_email, serializer: API::V2::ContactEmailMessageSerializer, status: :unprocessable_entity
        end
      end

      private

      def allowed_params
        params.from_jsonapi.require(:contact).permit(:text)
      end
    end
  end
end
