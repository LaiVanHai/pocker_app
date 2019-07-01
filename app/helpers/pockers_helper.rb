module PockersHelper
  def checkPockerHand(pocker_list)
    s_array = [] #Arrayとして、Sカードのナンバーを保存する
    h_array = [] #Arrayとして、Hカードのナンバーを保存する
    d_array = [] #Arrayとして、Dカードのナンバーを保存する
    c_array = [] #Arrayとして、Cカードのナンバーを保存する
    pocker_number_array = [] #５カードにナンバーを保存する

    @message = checkCardNumber(pocker_list)
    return @message unless @message.blank?

    @message = checkSuit(pocker_list)
    @message += "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" unless @message.blank?

    if @message.blank?
      pockers = pocker_list.split(" ")
      pockers.each_with_index do |pocker, index|
        current_pocker_suit = pocker[0].upcase
        current_pocker_number = pocker.slice(1..2).to_i
        case current_pocker_suit
        when "S"
          s_array.include?(current_pocker_number) ?
            @message = "カードが重複しています。" :
            s_array.push(current_pocker_number)
          break unless @message.blank?
        when "H"
          h_array.include?(current_pocker_number) ?
            @message = "カードが重複しています。" :
            h_array.push(current_pocker_number)
          break unless @message.blank?
        when "D"
          d_array.include?(current_pocker_number) ?
            @message = "カードが重複しています。" :
            d_array.push(current_pocker_number)
          break unless @message.blank?
        when "C"
          c_array.include?(current_pocker_number) ?
            @message = "カードが重複しています。" :
            c_array.push(current_pocker_number)
          break unless @message.blank?
        end
      end
      pocker_number_array = s_array + h_array + d_array + c_array
      # end of check suit and number
      if @message.blank?
        all_pocker_number_continuous = checkArrayContinuous(pocker_number_array)
        suit_arr = []
        suit_arr.push(s_array)
        suit_arr.push(h_array)
        suit_arr.push(d_array)
        suit_arr.push(c_array)
        if checkAllCardTogetherWithSuit(suit_arr)
          all_pocker_number_continuous ?
            @message = "ストレートフラッシュ" :
            @message = "フラッシュ"
        else #different suit
          all_pocker_number_continuous ?
            @message = "ストレート" :
            @message = checkGroup(pocker_number_array)
        end
      end
    end
    @message
  end

  def checkAllCardTogetherWithSuit(suit_arr)
    suit_arr.each do |suit|
      return true if suit.count == Settings.number_card
    end
    false
  end

  def checkCardNumber(pocker_list)
    #Pockerの５枚を足りるかどうか確認する
    @message = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)"
    return @message unless pocker_list.count(" ") == 4
    ""
  end

  def checkSuit(pocker_list)
    #Pockerのスートと数を確認する
    pockers = pocker_list.split(" ")
    respone_messages = ""
    pockers.each_with_index do |pocker, index|
      unless Settings.suit_list.include?(pocker[0].upcase) &&
        [*"1".."13"].include?(pocker.slice(1..3))
        respone_messages += (index + 1).to_s +
          "番目のカード指定文字が不正です。" +
          "(#{pocker})\n"
      end
    end
    respone_messages
  end

  def checkArrayContinuous(array_number)
    # array_numberは連続配列かどうか確認する
    arr = array_number.sort
    # 配列は順番通りに片付ける
    return true if arr[0] == 1 &&  arr[1] == 10
      # そんなケースを確認する：[1,13,12,11,10]
    for i in 0..3
      return false if arr[i+1] - arr[i] != 1
    end
    true
  end

  def checkGroup(array_number)
    # Pocker handのタイプを確認する
    # Array_number は五枚カードの数
    cur_arr = array_number
    dup2 = 0 #五枚の中に二枚の数は一緒
    dup3 = 0 #五枚の中に三枚の数は一緒
    dup4 = 0 #五枚の中に四枚の数は一緒
    while cur_arr.count != 0
      count = 1
      arr_length = cur_arr.count - 1
      for i in 1..arr_length
        count += 1 if cur_arr[0] == cur_arr[i]
        #同じ数を持っているカードを数える
      end
      case count
      when 2
        dup2 += 1
      when 3
        dup3 += 1
      when 4
        dup4 += 1
      end
      cur_arr.delete(cur_arr[0]) # 数えることを終わったら、そのElementを削除する
      count = 0
    end
    #check_result
    return "フォー・オブ・ア・カインド" if dup4 == 1

    if dup3 == 1
      dup2 == 1 ? msg = "フルハウス" : msg = "スリー・オブ・ア・カインド"
      return msg
    end

    return "ツーペア" if dup2 == 2

    dup2 == 1 ? msg = "ワンペア" : msg = "ハイカード"
    msg
  end

end
