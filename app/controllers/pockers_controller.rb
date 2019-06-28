class PockersController < ApplicationController

  include PockersHelper

  def top
  end

  def check
    @pocker_card = params[:card_list]
    @message = checkPockerHand(@pocker_card)
    render("pockers/top")
  end

end
