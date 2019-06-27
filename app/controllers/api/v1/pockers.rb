module API
  module V1
    class Pockers < Grape::API
      version 'v1', using: :header, vendor: 'api'
      format :json
      params do
        requires :cards, type: Array
      end

      resources :pockers do
        post do
          all_result = []
          msg = {}
          pocker_controller = PockersController.new
          params[:cards].each do |card|
            result = {}
            result["card"] = card
            result["hand"] = pocker_controller.checkPockerHand(card)
            result["hand"] == "ストレートフラッシュ" ?
              result["best"] = true : result["best"] = false
            all_result.push(result)
          end
          msg["result"] = all_result
          msg
        end
      end
    end
  end
end
