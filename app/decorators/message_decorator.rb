# frozen_string_literal: true

class MessageDecorator < BaseDecorator
  def render_body
    case type
    when 'text'
      @context.tag.p do
        data['text']
      end
    when 'file'
      @context.tag.div(class: 'message--image-container') do
        @context.image_tag(data['url'], class: 'message--image')
      end
    when 'POLL'
      poll_data = data['custom_data']

      "Poll Question: '#{poll_data['question']}' with answers '#{poll_data['answers'].join("', '")}'."
    when 'POLL_RESPONSE'
      poll_data = data['custom_data']

      "Poll Response: '#{poll_data['poll_answer']}' to question '#{poll_data['poll_question']}'."
    else
      "Unrecognized message type '#{type}'"
    end
  end

  def sender
    data.dig('entities', 'sender', 'entity')
  end

  def receiver
    data.dig('entities', 'receiver', 'entity')
  end

  def sent_at_time
    I18n.l(Time.zone.at(sent_at), format: '%-l:%M%P, %-d %b %Y')
  end
end
