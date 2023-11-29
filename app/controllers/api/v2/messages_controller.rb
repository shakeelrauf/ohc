# frozen_string_literal: true

class API::V2::MessagesController < API::V2::BaseController
  before_action :ensure_admin

  # == [DELETE] /api/v2/users/:user_chat_uid/messages/:id.json
  # Destroy a chat message
  # ==== Required
  # * user_chat_uid - the users CometChat UID
  # * id - the messages CometChat UID
  # ==== Returns
  # * 204 - success - message deleted
  # * 401 - failure - unauthorized
  # * 404 - failure - message not found

  def destroy
    Cometchat::Message.delete(params[:user_chat_uid], params[:id])

    head :no_content
  rescue Cometchat::ResponseError => error
    head error.code
  end

  def ensure_admin
    head :unauthorized unless current_user.admin?
  end
end
