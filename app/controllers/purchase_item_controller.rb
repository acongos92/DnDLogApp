class PurchaseItemController < ApplicationController
  include ApplicationHelper
  #
  # ensures character can afford, and updates if so
  #
  def buy
    @character = Character.find(params[:id])
    errors = findErrors(item_params)
    if errors.length < 1 && canAfford?(item_params[:cost].to_f, @character)
      @character.gp -= item_params[:cost].to_f
      @item = Item.new
      @item.character = @character
      @item.cost = item_params[:cost]
      @item.name = item_params[:name]
      @item.save
      @character.save
      redirect_to @character, notice: 'Item Was Purchased succesfully'
    else
      flash[:errors] = errors[0]
      @item = Item.new(item_params)
      render 'purchase_item/new'
    end
  end

  #
  # Renders Item Purchase form
  #
  def new
    @character = Character.find(params[:id])
    @item = Item.new
  end

  private
  #
  # Returns true if a character can afford a cost
  #
  def canAfford?(cost, character)
    return cost <= character.gp
  end

  private
  #
  # Checks for basic input errors and returns an array containing 0 or more error strings
  #
  def findErrors(params)
    errors = []
    if !isNumericVal(params[:cost])
      errors << "GP must be numeric value"
    else
      if params[:cost].to_f < 0
        errors << "GP must be a postivie value Nice try though ;)"
      end
    end
    return errors
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_params
    params.require(:item).permit(:name, :cost)
  end
end
