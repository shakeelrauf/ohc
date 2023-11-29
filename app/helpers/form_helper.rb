# frozen_string_literal: true

module FormHelper
  def attachment_file_field(form, attribute, options = {})
    attachment = form.object&.send(attribute)

    render 'shared/attachment_file_field', f: form, attribute: attribute, attachment: attachment, options: options
  end

  def grouped_options_for_user_select(selected_user_id)
    grouped_options_for_select(
      {
        'Admins': options_for_user_collection(user_collection_for(User::Admin)),
        'Children': options_for_user_collection(user_collection_for(User::Child))
      },
      selected_user_id
    )
  end

  private

  def options_for_user_collection(user_collection)
    user_collection.map { |user| [user.full_name, user.id] }
  end

  def user_collection_for(model)
    model.accessible_by(current_ability).order(:last_name, :first_name)
  end
end
