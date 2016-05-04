# http://matthewlehner.net/rails-api-testing-guidelines/
# Helper modele to parse json body

module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end
end