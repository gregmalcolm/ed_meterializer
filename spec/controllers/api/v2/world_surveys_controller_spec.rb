require 'rails_helper'
require 'support/helpers/auth_helper.rb'

describe Api::V2::WorldSurveysController, type: :controller do
  include AuthHelper
  include WorldsHelper
  include WorldSurveysHelper
  
  let!(:worlds) { spawn_worlds }
  let!(:world_surveys) { spawn_world_surveys(world1: worlds[0], world2: worlds[1], world3: worlds[2]) }
  let(:json) { JSON.parse(response.body)}

  describe "GET #index" do
    let(:world_surveys_json) { json["world_surveys"] }
    let(:updaters) { world_surveys_json.map { |j| j["updater"] } }

    context "drinking from the firehouse" do
      before { get :index, {world_id: worlds[0].id} }
      it { expect(response).to have_http_status(200) }
      it { expect(world_surveys_json[0]["carbon"]).to be true }
      it { expect(world_surveys_json.size).to be == 1 }
    end

    describe "filtering" do
      context "on world_id" do
        before { get :index, {world_id: worlds[1].id} }
        it { expect(world_surveys_json[0]["updater"]).to be == "Finwen" }
        it { expect(world_surveys_json.size).to be == 1 }
      end
      
      context "on updater" do
        before { get :index, {world_id: worlds[2].id, 
                              updater: "  DommAARRAA "} }
        it { expect(world_surveys_json[0]["updater"]).to be == "Dommaarraa" }
        it { expect(world_surveys_json.size).to be == 1 }
      end

      context "on updated_before" do
        before { get :index, {updated_before: Time.now - 8.days} }
        it { expect(updaters).to include "Marlon Blake" }
        it { expect(world_surveys_json.size).to be == 1 }
      end

      context "on updated_after" do
        before { get :index, {updated_after: Time.now - 8.days} }
        it { expect(updaters).to include "Finwen" }
        it { expect(updaters).to include "Dommaarraa" }
        it { expect(world_surveys_json.size).to be == 2 }
      end
    end
  end

  describe "GET #show" do
    let(:world_survey) { json["world_survey"] }

    context "nested" do
      before { get :show, {id: world_surveys[2].id, 
                           world_id: worlds[1].id} }
      it { expect(response).to have_http_status(200) }
      it { expect(world_survey["iron"]).to be true }
    end
    
    context "not nested" do
      before { get :show, {id: world_surveys[2].id} }
      it { expect(response).to have_http_status(200) }
      it { expect(world_survey["iron"]).to be true }
    end
  end
end
