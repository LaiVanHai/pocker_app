require 'rails_helper'

RSpec.describe PockersHelper, type: :helper do
  describe "checkCardNumber" do
    context "When card number is wrong" do
      before { @error_msg = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)" }
      it "Card number less than standard amount" do
        pocker_list = "C7 C6 C5"
        expect(helper.checkPockerHand(pocker_list)).to eq @error_msg
      end

      it "Card number more than standard amount" do
        pocker_list = "C7 C6 C5 C9 C10 C11"
        expect(helper.checkPockerHand(pocker_list)).to eq @error_msg
      end

      it "The card number is correct but there is a strange keyword between each card" do
        pocker_list = "C7  C6 C5 C9 C10"
        expect(helper.checkPockerHand(pocker_list)).to eq @error_msg
        pocker_list2 = "c7 C6 C5 C9 C10  "
        expect(helper.checkPockerHand(pocker_list2)).to eq @error_msg
        pocker_list2 = "  C7 C6 C5 d9 C10"
        expect(helper.checkPockerHand(pocker_list2)).to eq @error_msg
      end
    end
  end

  describe "checkPockerHand" do
    context "When pocker hand is correct" do
      it "Pocker hand true" do
        pocker_list = "c7 C6 c5 C4 C3"
        expect(helper.checkPockerHand(pocker_list)).to eq "ストレートフラッシュ"
      end
    end

    context "When pocker hand is wrong" do
      it "Card suit is wrong - T7 Card" do
        pocker_list = "T7 C6 C5 C9 C10"
        error_msg = "1番目のカード指定文字が不正です。(T7)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        expect(helper.checkPockerHand(pocker_list)).to eq error_msg
      end

      it "Card suit is wrong - T7,T8 Card" do
        pocker_list = "T7 C6 C5 C9 T8"
        error_msg = "1番目のカード指定文字が不正です。(T7)\n5番目のカード指定文字が不正です。(T8)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        expect(helper.checkPockerHand(pocker_list)).to eq error_msg
      end

      it "Card number is wrong - T70 Card" do
        pocker_list = "T70 C6 C5 C9 C10"
        error_msg = "1番目のカード指定文字が不正です。(T70)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        expect(helper.checkPockerHand(pocker_list)).to eq error_msg
      end

      it "Card number is wrong - T70, C50 Card" do
        pocker_list = "T70 C6 C50 C9 C10"
        error_msg = "1番目のカード指定文字が不正です。(T70)\n3番目のカード指定文字が不正です。(C50)\n半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        expect(helper.checkPockerHand(pocker_list)).to eq error_msg
      end
    end
  end

  describe "checkPockerHand" do
    context "When pocker hand is correct" do
      it "Pocker hand is ストレートフラッシュ" do
        pocker_list = "H1 H13 H12 H11 H10"
        expect(helper.checkPockerHand(pocker_list)).to eq "ストレートフラッシュ"
      end

      it "Pocker hand is フォー・オブ・ア・カインド" do
        pocker_list = "D5 D6 H6 S6 C6"
        expect(helper.checkPockerHand(pocker_list)).to eq "フォー・オブ・ア・カインド"
      end

      it "Pocker hand is フルハウス" do
        pocker_list = "H9 C9 S9 H1 C1"
        expect(helper.checkPockerHand(pocker_list)).to eq "フルハウス"
      end

      it "Pocker hand is フラッシュ" do
        pocker_list = "H1 H12 H10 H5 H3"
        expect(helper.checkPockerHand(pocker_list)).to eq "フラッシュ"
      end

      it "Pocker hand is ストレート" do
        pocker_list = "S8 S7 H6 H5 S4"
        expect(helper.checkPockerHand(pocker_list)).to eq "ストレート"
      end

      it "Pocker hand is スリー・オブ・ア・カインド" do
        pocker_list = "S12 C12 D12 S5 C3"
        expect(helper.checkPockerHand(pocker_list)).to eq "スリー・オブ・ア・カインド"
      end

      it "Pocker hand is ツーペア" do
        pocker_list = "H13 D13 C2 D2 H11"
        expect(helper.checkPockerHand(pocker_list)).to eq "ツーペア"
      end

      it "Pocker hand is ワンペア" do
        pocker_list = "C10 S10 S6 H4 H2"
        expect(helper.checkPockerHand(pocker_list)).to eq "ワンペア"
      end

      it "Pocker hand is ハイカード" do
        pocker_list = "D1 D10 S9 C5 C4"
        expect(helper.checkPockerHand(pocker_list)).to eq "ハイカード"
      end
    end

    context "When pocker card is duplicated" do
      it "Pocker hand is duplicated" do
        pocker_list = "C7 C6 C5 C7 C9"
        expect(helper.checkPockerHand(pocker_list)).to eq "カードが重複しています。"
      end
    end
  end
end
