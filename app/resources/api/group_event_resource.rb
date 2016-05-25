module Api
  class GroupEventResource < JSONAPI::Resource
    attributes :name, :status, :location, :description, :start_date, :end_date
    attribute :duration

    has_one :user

    before_save :check_status
    before_update :check_status

    def duration
      (@model.end_date - @model.start_date).to_i
    end

    def check_status
      if @model.location.present? && @model.description.present?
        @model.status = "published"
      end
    end
  end
end

