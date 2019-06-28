module PockersHelper
  def checkPockerHand(pocker_list)
    s_array = [] #Arrayとして、Sカードのナンバーを保存する
    h_array = [] #Arrayとして、Hカードのナンバーを保存する
    d_array = [] #Arrayとして、Dカードのナンバーを保存する
    c_array = [] #Arrayとして、Cカードのナンバーを保存する
    pocker_number_array = [] #５カードにナンバーを保存する

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
            # 各カードの数は一意なので、配列の中に既存なら、重複のケースだ
            @message = "カードが重複しています。"
            break
          else
            s_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(H h).include?(current_pocker_suit)
          if h_array.include?(current_pocker_number)
            # 各カードの数は一意なので、配列の中に既存なら、重複のケースだ
            @message = "カードが重複しています。"
            break
          else
            h_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(D d).include?(current_pocker_suit)
          if d_array.include?(current_pocker_number)
            # 各カードの数は一意なので、配列の中に既存なら、重複のケースだ
            @message = "カードが重複しています。"
            break
          else
            d_array.push(current_pocker_number)
            pocker_number_array.push(current_pocker_number)
          end
        elsif %w(C c).include?(current_pocker_suit)
          if c_array.include?(current_pocker_number)
            # 各カードの数は一意なので、配列の中に既存なら、重複のケースだ
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

  def checkCardNumber(pocker_list)
    #Pockerの５枚を足りるかどうか確認する
    @message = ""
    if pocker_list.count(" ") != 4
      @message = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)"
    end
    @message
  end

  def checkSuit(pocker_list)
    #Pockerのスートと数を確認する
    pockers = pocker_list.split(" ")
    words = %w(S H D C s h d c) #スートのArray
    respone_messages = ""
    pockers.each_with_index do |pocker, index|
      unless words.include?(pocker[0]) &&
        [*"1".."13"].include?(pocker.slice(1..3))
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

  def checkArrayContinuous(array_number)
    # array_numberは連続配列かどうか確認する
    arr = array_number.sort
    # 配列は順番通りに片付ける
    if arr[0] == 1 &&  arr[1] == 10
      # そんなケースを確認する：[1,13,12,11,10]
      return true
    end
    for i in 0..3
      if arr[i+1] - arr[i] != 1
        return false
      end
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
        if cur_arr[0] == cur_arr[i]
          count += 1 #同じ数を持っているカードを数える
        end
      end
      if count == 2
        dup2 += 1
      elsif count == 3
        dup3 += 1
      elsif count == 4
        dup4 += 1
      end
      cur_arr.delete(cur_arr[0]) # 数えることを終わったら、そのElementを削除する
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
