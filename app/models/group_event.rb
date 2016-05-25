class GroupEvent < ActiveRecord::Base
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :user

  acts_as_paranoid
end
