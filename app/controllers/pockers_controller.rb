class PockersController < ApplicationController
  def top
  end

  def check
    @pocker_card = params[:card_list]
    @message = checkPockerHand(@pocker_card)
    render("pockers/top")
  end

  def checkPockerHand(pocker_list)
    suit_array = []
    s_array = []
    h_array = []
    d_array = []
    c_array = []
    pocker_number_array = []
    @message = checkCardNumber(pocker_list)
    if @message == ""
      @message = checkSuit(pocker_list).strip
    else
      return @message
    end

    if @message == ""
      pockers = pocker_list.split(" ")
      pockers.each_with_index do |pocker, index|
        current_pocker_suit = pocker[0]
        current_pocker_number = pocker.slice(1..2).to_i
        if %w(S s).include?(current_pocker_suit)
          if s_array.include?(current_pocker_number)
            @message = "カードが重複しています。"
            break
          else
            s_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(H h).include?(current_pocker_suit)
          if h_array.include?(current_pocker_number)
            @message = "カードが重複しています。"
            break
          else
            h_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(D d).include?(current_pocker_suit)
          if d_array.include?(current_pocker_number)
            @message = "カードが重複しています。"
            break
          else
            d_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(C c).include?(current_pocker_suit)
          if c_array.include?(current_pocker_number)
            @message = "カードが重複しています。"
            break
          else
            c_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        end
      end
      # end of check suit and number
      if @message == ""
        all_pocker_number_continuous = checkArrayContinuous(pocker_number_array)
        if s_array.count == 5 || h_array.count == 5 ||
          d_array.count == 5 || c_array.count == 5
          if all_pocker_number_continuous
            @message = "ストレートフラッシュ"
          else
            @message = "フラッシュ"
          end
        else #different suit
          if all_pocker_number_continuous
            @message = "ストレート"
          else
            @message = checkGroup(pocker_number_array)
          end
        end
      end
    end
    @message
  end

  private

  def checkCardNumber(pocker_list)
    @message = ""
    if pocker_list.count(" ") != 4
      @message = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)"
    end
    @message
  end

  def checkSuit(pocker_list)
    pockers = pocker_list.split(" ")
    words = %w(S H D C s h d c)
    respone_messages = ""
    pockers.each_with_index do |pocker, index|
      unless words.include?(pocker[0]) &&
        pocker.slice(1..3).to_i >= 1 &&
        pocker.slice(1..3).to_i <= 13
        respone_messages += (index + 1).to_s +
          "番目のカード指定文字が不正です。" +
          "(#{pocker})\n"
      end
    end
    unless respone_messages == ""
      respone_messages += "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
    end
    respone_messages
  end

  def checkArrayContinuous(array_number) # array of element: 5
    arr = array_number.sort
    if arr[0] == 1 &&  arr[1] == 10
      return true
    end

    for i in 0..3
      if arr[i+1] - arr[i] != 1
        return false
      end
    end
    true
  end

  def checkGroup(array_number) # array of element: 5
    cur_arr = array_number
    dup2 = 0
    dup3 = 0
    dup4 = 0
    while cur_arr.count != 0
      count = 1
      arr_length = cur_arr.count - 1
      for i in 1..arr_length
        if cur_arr[0] == cur_arr[i]
          count += 1
        end
      end
      if count == 2
        dup2 += 1
      elsif count == 3
        dup3 += 1
      elsif count == 4
        dup4 += 1
      end
      cur_arr.delete(cur_arr[0])
      count = 0
    end
    #check_result
    if dup4 == 1
      return "フォー・オブ・ア・カインド"
    elsif dup3 == 1
      if dup2 == 1
        return "フルハウス"
      else
        return "スリー・オブ・ア・カインド"
      end
    elsif dup2 == 2
      return "ツーペア"
    elsif dup2 == 1
      return "ワンペア"
    else
      return "ハイカード"
    end
  end

end
