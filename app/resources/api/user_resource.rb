module Api
  class UserResource < JSONAPI::Resource
    attribute :name

    has_many :group_events
  end
end
