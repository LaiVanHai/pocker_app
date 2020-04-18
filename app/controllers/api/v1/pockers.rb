module API
  module V1
    class Pockers < Grape::API
      include Pokers::CheckService
      version 'v1', using: :header, vendor: 'api'
      format :json
      params do
        requires :cards, type: Array
        #パラメーターを確認する
      end

      resources :pockers do
        post do
          all_result_normal = [] #正常結果を保存する配列
          all_result_wrong = [] #異常結果を保存する配列
          min = 10;
          msg= {} #返却データ
          params[:cards].each do |card|
            suit_result = Pokers::CheckService.checkPockerHand(card)
            if Settings.suits.include?(suit_result)
              result = {} #Hashで一つのカードの処理結果を保存する
              result["card"] = card
              result["hand"] = suit_result
              suit_result_index = Settings.suits.index(suit_result)
              result["best"] = false
              min = suit_result_index if min > suit_result_index
              all_result_normal.push(result)
            else
              suit_result.split("\n").each do |suit_rel|
                result = {} #Hashで一つのカードの処理結果を保存する
                result["card"] = card
                result["msg"] = suit_rel
                # を追加しない
                all_result_wrong.push(result) unless result["msg"] == "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
              end
            end
          end

          all_result_normal.each do |result|
            result["best"] = true unless result["hand"] != Settings.suits[min]
          end

          msg["result"] = all_result_normal unless all_result_normal.length == 0
          msg["error"] = all_result_wrong unless all_result_wrong.length == 0
          msg
        end
      end
    end
  end
end
