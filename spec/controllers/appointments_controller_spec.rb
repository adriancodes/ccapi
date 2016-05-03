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
            expect(response.content_type).to eq(Mime::JSON)
        end
    end
end
