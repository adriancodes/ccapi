require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
    before :each do
      @request.env["HTTP_ACCEPT"] = Mime::JSON.to_s
    end

    describe "GET #list" do
        it "should respond successfully with JSON" do
            get :list
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq(Mime::JSON)
        end
    end

    describe "GET #list" do
        it "should respond successfully with JSON" do
            get :list, {:id => '1'}
            expect(response).to have_http_status(200)
        end
    end

    describe "GET #list with resource that doesn't exist " do
        it "should responsd with not found status code" do
            get :list, {:id => '1000'}
            expect(response).to have_http_status(404)
        end
    end

    describe "GET #list with dates " do
        it "should not be empty when filtering dates" do
            get :list, {start_time: "11/8/13 8:00", end_time: "11/11/13 8:00"}
            resp = JSON.parse(response.body)
            expect(resp).not_to be_empty
            expect(resp.length).to be < 168 # The number of initial entries
        end
    end

    describe "GET #list with dates " do
        it "should be empty when dates are out of range" do
            get :list, {start_time: "11/8/18 8:00", end_time: "11/11/18 8:00"}
            resp = JSON.parse(response.body)
            expect(resp).to be_empty
        end
    end

    describe "GET #list with dates " do
        it "should be raise 400 if one of the end date is missing" do
            get :list, {start_time: "11/8/18 8:00"}
            expect(response).to have_http_status(400)
        end
    end

    describe "GET #list with dates " do
        it "should be raise 400 if one of the start date is missing" do
            get :list, {end_time: "11/11/18 8:00"}
            expect(response).to have_http_status(400)
        end
    end
end
