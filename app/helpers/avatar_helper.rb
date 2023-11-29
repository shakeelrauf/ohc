# frozen_string_literal: true

module AvatarHelper
  PATHS = {
    'AVATAR_ADMIN' => 'avatars/admin.svg',
    'BROWN_BEAR' => 'avatars/bear.svg',
    'FOX' => 'avatars/fox.svg',
    'GOOSE' => 'avatars/goose.svg',
    'MOOSE' => 'avatars/moose.svg',
    'OTTER' => 'avatars/otter.svg',
    'OWL' => 'avatars/owl.svg',
    'RABBIT' => 'avatars/rabbit.svg',
    'SEAL' => 'avatars/seal.svg',
    'WOLF' => 'avatars/wolf.svg'
  }.freeze

  def avatar_image(user)
    image_tag(avatar_path(user), class: 'messages--admin-avatar')
  end

  private

  def avatar_path(user)
    avatar = user&.avatar

    avatar.present? ? PATHS[avatar] : PATHS[default_avatar(user)]
  end

  def default_avatar(user)
    user&.is_a?(User::Admin) ? 'AVATAR_ADMIN' : 'FOX'
  end
end
