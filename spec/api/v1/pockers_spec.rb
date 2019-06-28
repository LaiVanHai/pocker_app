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
    it 'A strange card is in the poker hand' do
      post '/api/pockers', params: {"cards": ["H1 H13 H12 H11 H10","H9 C9 S9 H2 C2","C13 D12 C11 H8"]}
      expect(response.content_type).to eq("application/json")
      expect(response).to	be_successful
      expect(JSON.parse(response.body)["result"][0]["best"]).to be true
      expect(JSON.parse(response.body)["result"][0]["card"]).to eq("H1 H13 H12 H11 H10")
      expect(JSON.parse(response.body)["result"][0]["hand"]).to eq("ストレートフラッシュ")
      expect(JSON.parse(response.body)["result"][2]["best"]).to be false
      expect(JSON.parse(response.body)["result"][2]["card"]).to eq("C13 D12 C11 H8")
      expect(JSON.parse(response.body)["result"][2]["hand"]).to eq("5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)")
    end
  end
end
