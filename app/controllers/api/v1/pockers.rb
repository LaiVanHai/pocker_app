module API
  module V1
    class Pockers < Grape::API
      version 'v1', using: :header, vendor: 'api'
      format :json
      params do
        requires :cards, type: Array
        #パラメーターを確認する
      end

      resources :pockers do
        post do
          all_result = []
          msg = {} #返却データ
          pocker_controller = PockersController.new
          params[:cards].each do |card|
            result = {} #Hashで一つのカードの処理結果を保存する
            result["card"] = card
            result["hand"] = pocker_controller.checkPockerHand(card)
            result["hand"] == "ストレートフラッシュ" ?
              result["best"] = true : result["best"] = false
              #もっと強いカードかどうか確認する
            all_result.push(result)
            #各処理結果はArrayに追加する
          end
          msg["result"] = all_result
          msg
        end
      end
    end
  end
end
