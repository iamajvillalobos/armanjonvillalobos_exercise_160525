require 'rails_helper'

describe "Group Events API" do
  before :each do
    @user = User.create(name: "Arya Stark")
  end

  describe "GET /api/users/:id?include=group-events" do
    it "returns the group events for user" do
      group_event = GroupEvent.create(
        name: "Another great event!",
        start_date: "2016-05-23",
        end_date: "2016-05-30",
        user: @user)

      get "/api/users/#{@user.id}?include=group-events"

      body = JSON.parse(response.body)
      group_events = body['included'].map { |m| m['attributes']['name'] }

      expect(response.status).to eq(200)
      expect(group_events).to match_array(["Another great event!"])
    end
  end

  describe "POST /api/users/:id/group_events" do
    context "with valid params" do
      it "adds a new group event and status is draft" do
        payload = {
          "data": {
            "type": "group-events",
            "attributes": {
              "name": "Best Event Ever",
              "start-date": "2016-05-24",
              "end-date": "2016-05-30"
            },
            "relationships": {
              "user": {
                "data": {
                  "type": "users",
                  "id": "#{@user.id}"
                }
              }
            }
          }
        }

        post "/api/users/#{@user.id}/group-events", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

        body = JSON.parse(response.body)['data']
        group_event = body['attributes']

        expect(group_event['name']).to eq("Best Event Ever")
        expect(group_event['status']).to eq("draft")
      end
    end

    context "with complete params" do
      it "adds a new group event and status is published" do
        payload = {
          "data": {
            "type": "group-events",
            "attributes": {
              "name": "Best Event Ever",
              "start-date": "2016-05-24",
              "end-date": "2016-05-30",
              "location": "Philippines",
              "description": "Biggest Event Yet!"
            },
            "relationships": {
              "user": {
                "data": {
                  "type": "users",
                  "id": "#{@user.id}"
                }
              }
            }
          }
        }

        post "/api/users/#{@user.id}/group-events", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

        body = JSON.parse(response.body)['data']
        group_event = body['attributes']

        expect(group_event['name']).to eq("Best Event Ever")
        expect(group_event['status']).to eq("published")
      end
    end

    context "with incomplete params" do
      it "adds a new group event and status is draft" do
        payload = {
          "data": {
            "type": "group-events",
            "attributes": {
              "name": "Best Event Ever",
              "start-date": "2016-05-24",
              "end-date": "2016-05-30",
              "location": "Philippines",
            },
            "relationships": {
              "user": {
                "data": {
                  "type": "users",
                  "id": "#{@user.id}"
                }
              }
            }
          }
        }

        post "/api/users/#{@user.id}/group-events", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

        body = JSON.parse(response.body)['data']
        group_event = body['attributes']

        expect(group_event['name']).to eq("Best Event Ever")
        expect(group_event['status']).to eq("draft")
      end
    end
  end

  describe "PATCH /api/users/:id/group-events/:id" do
    it "returns the updated group event" do
      group_event = GroupEvent.create(
        name: "Superb Event!",
        start_date: "2016-05-23",
        end_date: "2016-05-30",
        user: @user)

      payload = {
        "data": {
          "type": "group-events",
          "id": "#{group_event.id}",
          "attributes": {
            "name": "Another Awesome Event!"
          }
        }
      }

      patch "/api/users/#{@user.id}/group-events/#{group_event.id}", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

      body = JSON.parse(response.body)
      group_event = body['data']['attributes']

      expect(response.status).to eq(200)
      expect(group_event['name']).to eq("Another Awesome Event!")
    end

    it "returns the published status if group event has all fields completed" do
      group_event = GroupEvent.create(
        name: "Superb Event!",
        start_date: "2016-05-23",
        end_date: "2016-05-30",
        user: @user)

      expect(group_event.status).to eq("draft")

      payload = {
        "data": {
          "type": "group-events",
          "id": "#{group_event.id}",
          "attributes": {
            "location": "Philippines",
            "description": "Event of the Year!"
          }
        }
      }

      patch "/api/users/#{@user.id}/group-events/#{group_event.id}", payload.to_json, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

      body = JSON.parse(response.body)
      group_event = body['data']['attributes']

      expect(group_event['status']).to eq("published")
    end
  end

  describe "DELETE /api/isers/:id/group-events/:id" do
    it "removes a group event" do
       group_event1 = GroupEvent.create(
        name: "Superb Event!",
        start_date: "2016-05-23",
        end_date: "2016-05-30",
        user: @user)
       group_event2 = GroupEvent.create(
        name: "Another Superb Event!",
        start_date: "2016-05-23",
        end_date: "2016-05-30",
        user: @user)

        delete "api/users/#{@user.id}/group-events/#{group_event1.id}", {}, { 'CONTENT-TYPE' => 'application/vnd.api+json' }

        expect(response.status).to eq(204)
    end
  end
end