require 'rails_helper'

RSpec.describe "Pockers", :type => :request do
  describe "Check request parameters" do
    it "Wrong parameter" do
      post '/api/pockers', params: {"cards2": ["H1 H13 H12 H11 H10"]}
      expect(response.content_type).to eq("application/json")
      expect(response).to_not	be_successful
    end

    it "Correct parameter" do
      post '/api/pockers', params: {"cards": ["H1 H13 H12 H11 H10"]}
      expect(response.content_type).to eq("application/json")
      expect(response).to	be_successful
    end
  end

  describe "Check pocker hand" do
    context "When normal respond" do
      it 'Poker and has only normal results' do
        post '/api/pockers', params: {"cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response.content_type).to eq("application/json")
        expect(response).to	be_successful
        expect(JSON.parse(response.body)["result"][0]["best"]).to be true
        expect(JSON.parse(response.body)["result"][0]["card"]).to eq("H1 H13 H12 H11 H10")
        expect(JSON.parse(response.body)["result"][0]["hand"]).to eq("ストレートフラッシュ")
        expect(JSON.parse(response.body)["result"][2]["best"]).to be false
        expect(JSON.parse(response.body)["result"][2]["card"]).to eq("C13 D12 C11 H8 H7")
        expect(JSON.parse(response.body)["result"][2]["hand"]).to eq("ハイカード")
        expect(JSON.parse(response.body)["error"]).to be_nil
      end
    end
    context "When wrong respone" do
      it "Poker and has only wrong results" do
        post '/api/pockers', params: {"cards": ["H9 C9 S90 H1 C1", "C10 D10 H10 S10 D60"]}
        expect(response.content_type).to eq("application/json")
        expect(response).to	be_successful
        expect(JSON.parse(response.body)["error"][0]["card"]).to eq("H9 C9 S90 H1 C1")
        expect(JSON.parse(response.body)["error"][0]["msg"]).to eq("3番目のカード指定文字が不正です。(S90)")
        expect(JSON.parse(response.body)["error"][1]["card"]).to eq("C10 D10 H10 S10 D60")
        expect(JSON.parse(response.body)["error"][1]["msg"]).to eq("5番目のカード指定文字が不正です。(D60)")
        expect(JSON.parse(response.body)["result"]).to be_nil
      end

      it "Poker hand results are both good and bad" do
        post '/api/pockers', params: {"cards": ["H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7", "C10 D10 H100 S10 D6"]}
        expect(response.content_type).to eq("application/json")
        expect(response).to	be_successful
        expect(JSON.parse(response.body)["result"][0]["best"]).to be true
        expect(JSON.parse(response.body)["result"][0]["card"]).to eq("H9 C9 S9 H2 C2")
        expect(JSON.parse(response.body)["result"][0]["hand"]).to eq("フルハウス")
        expect(JSON.parse(response.body)["result"][1]["best"]).to be false
        expect(JSON.parse(response.body)["result"][1]["card"]).to eq("C13 D12 C11 H8 H7")
        expect(JSON.parse(response.body)["result"][1]["hand"]).to eq("ハイカード")
        expect(JSON.parse(response.body)["error"][0]["card"]).to eq("C10 D10 H100 S10 D6")
        expect(JSON.parse(response.body)["error"][0]["msg"]).to eq("3番目のカード指定文字が不正です。(H100)")
      end

      it "Poker hand two cards in the abnormal result" do
        post '/api/pockers', params: {"cards": ["C10 D10 H100 S10 D60"]}
        expect(response.content_type).to eq("application/json")
        expect(response).to	be_successful
        expect(JSON.parse(response.body)["error"][0]["card"]).to eq("C10 D10 H100 S10 D60")
        expect(JSON.parse(response.body)["error"][0]["msg"]).to eq("3番目のカード指定文字が不正です。(H100)")
        expect(JSON.parse(response.body)["error"][1]["card"]).to eq("C10 D10 H100 S10 D60")
        expect(JSON.parse(response.body)["error"][1]["msg"]).to eq("5番目のカード指定文字が不正です。(D60)")
        expect(JSON.parse(response.body)["result"]).to be_nil
      end

      it "Poker hand less than five" do
        post '/api/pockers', params: {"cards": ["C10 D10 H10"]}
        expect(response.content_type).to eq("application/json")
        expect(response).to	be_successful
        expect(JSON.parse(response.body)["error"][0]["card"]).to eq("C10 D10 H10")
        expect(JSON.parse(response.body)["error"][0]["msg"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)")
      end
    end
  end
end
