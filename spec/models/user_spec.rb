require 'rails_helper'

describe User do
  it "is valid with name" do
    user = User.new(name: "Ned Stark")
    expect(user.valid?).to be_truthy
  end

  it "is invalid without a name" do
    user = User.new(name: nil)
    expect(user.valid?).to be_falsy
  end
end