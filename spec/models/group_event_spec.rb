require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  before :each do

  end

  it "is valid with name, start date and end date" do
    group_event = GroupEvent.new(
      name: "Awesome event",
      start_date: "2016-05-24",
      end_date: "2016-05-26")

    expect(group_event.valid?).to be_truthy
  end

  it "is invalid without name" do
    group_event = GroupEvent.new(name: nil)
    group_event.valid?
    expect(group_event.errors[:name]).to include("can't be blank")
  end

  it "is invalid without start date" do
    group_event = GroupEvent.new(start_date: nil)
    group_event.valid?
    expect(group_event.errors[:start_date]).to include("can't be blank")
  end

  it "is invalid without end date" do
    group_event = GroupEvent.new(end_date: nil)
    group_event.valid?
    expect(group_event.errors[:end_date]).to include("can't be blank")
  end
end
