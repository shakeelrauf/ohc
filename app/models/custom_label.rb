# frozen_string_literal: true

class CustomLabel < ApplicationRecord
  CLASSES = ['Cabin',
             'Camp',
             'CampLocation',
             'Event::CabinEvent',
             'Event::CampEvent',
             'Event::NationalEvent',
             'MediaItem::CampMediaItem',
             'MediaItem::NationalMediaItem',
             'User::Child',
             'Season'].freeze

  belongs_to :tenant

  validates :class_name, presence: true, inclusion: { in: CLASSES }
end
