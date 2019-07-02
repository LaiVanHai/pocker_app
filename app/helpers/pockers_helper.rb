module PockersHelper
  def checkPockerHand(pocker_list)
    pocker_number_array = [] #５カードにナンバーを保存する
    pocker_suit_hash = {} #Arrayとして、 各スートのナンバーを保存する
    Settings.suit_list.each do |suit|
      pocker_suit_hash[suit] = []
      # S,H,C,D配列を作成する
    end

    message = validation(pocker_list, pocker_suit_hash)
    return message if message.present?

    Settings.suit_list.each do |suit|
      pocker_number_array += pocker_suit_hash[suit]
    end
    all_pocker_number_continuous = checkArrayContinuous(pocker_number_array)

    if checkAllCardTogetherWithSuit(pocker_suit_hash)
      all_pocker_number_continuous ?
        message = "ストレートフラッシュ" :
        message = "フラッシュ"
    else #different suit
      all_pocker_number_continuous ?
        message = "ストレート" :
        message = checkGroup(pocker_number_array)
    end
    message
  end

  private

  def validation(pocker_list, pocker_suit_hash)
    #　カードの数枚を確認する
    msg = "5つのカード指定文字を半角スペース区切りで入力してください。（例：S1 H3 D9 C13 S11)"
    return msg if pocker_list.count(" ") != (Settings.number_card - 1)

    message = checkSuit(pocker_list)
    # カードのスートを確認する
    message += \
      "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。" \
      if message.present?
    # メッセージ内容を捕捉する
    return message if message.present?

    pockers = pocker_list.split(" ")
    pockers.each_with_index do |pocker, index|
      current_pocker_suit = pocker[0].upcase
      current_pocker_number = pocker.slice(1..2).to_i
      pocker_suit_hash[current_pocker_suit].include?(current_pocker_number) ?
        message = "カードが重複しています。" :
        pocker_suit_hash[current_pocker_suit].push(current_pocker_number)
      break if message.present?
    end
    message
  end

  def checkAllCardTogetherWithSuit(suit_arr)
    Settings.suit_list.each do |suit|
      return true if suit_arr[suit].count == Settings.number_card
    end
    false
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
    loop_length = Settings.number_card - 2
    # 配列は順番通りに片付ける
    return true if arr[0] == 1 &&  arr[1] == 10
      # そんなケースを確認する：[1,13,12,11,10]
    for i in 0..loop_length
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
