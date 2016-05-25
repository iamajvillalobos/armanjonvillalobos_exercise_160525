require 'rails_helper'

describe "Users API" do
  context "GET /api/users" do
    it "returns an array of users" do
      User.create(name: "Jon Snow")
      User.create(name: "Arya Stark")

      get "/api/users"

      body = JSON.parse(response.body)['data']
      users = body.map { |m| m['attributes']['name'] }

      expect(response.status).to eq(200)
      expect(users).to match_array ['Jon Snow', 'Arya Stark']
    end    
  end

  context "GET /api/users/:id" do
    it "returns a user" do
      user = User.create(name: "Bran Stark")

      get "/api/users/#{user.id}"

      body = JSON.parse(response.body)['data']
      user = body['attributes']

      expect(response.status).to eq(200)
      expect(user['name']).to eq("Bran Stark")
    end
  end

  context "POST /api/users" do
    it "returns a new user" do
      payload = {
        "data": {
          "type": "users",
          "attributes": {
            "name": "Melisandre"
          }
        }
      }

      post "/api/users", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

      body = JSON.parse(response.body)['data']
      user = body['attributes']

      expect(response.status).to eq(201)
      expect(user['name']).to eq("Melisandre")
    end
  end

  context "PATCH /api/users/:id" do
    it "returns an updated user" do
      user = User.create(name: "Tyrion Lannister")
      payload = {
        "data": {
          "id": "#{user.id}",
          "type": "users",
          "attributes": {
            "name": "Jaime Lannister"
          }
        }
      }

      patch "/api/users/#{user.id}", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

      body = JSON.parse(response.body)['data']
      user = body['attributes']

      expect(response.status).to eq(200)
      expect(user['name']).to eq("Jaime Lannister")
    end
  end

  context "DELETE /api/users/:id" do
    it "removes a user" do
      user1 = User.create(name: "Ramsey Bolton")
      user2 = User.create(name: "Jorah Mormont")

      delete "/api/users/#{user1.id}", {}, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

      expect(response.status).to eq(204)
    end
  end
end