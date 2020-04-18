class PockersController < ApplicationController

  include Pokers::CheckService

  def top
  end

  def check
    @pocker_card = params[:card_list]
    @message = Pokers::CheckService.checkPockerHand(@pocker_card)
    render("pockers/top")
  end

end
