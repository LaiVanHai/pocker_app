module API
  module V1
    class Base < Grape::API
      mount V1::Pockers
      # mount API::V1::AnotherResource
    end
  end
end
