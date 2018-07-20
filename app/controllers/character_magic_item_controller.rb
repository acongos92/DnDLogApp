class CharacterMagicItemController < ApplicationController

  def show
    @magic_items = MagicItem.all.order(:name)
    @character = Character.find(params[:id])
    render 'character_magic_item/form'
  end

  def buy
    @magic_item = MagicItem.where(name: get_item_name(params[:magic_item]))[0]
    @character = Character.find(params[:id])
    if @magic_item.nil?
      flash[:error] = "Please use one of the autofill options"
      @magic_items = MagicItem.all
      render 'character_magic_item/form'
    else
      association = CharacterMagicItem.new
      association.character_id = params[:id]
      association.magic_item_id = @magic_item.id
      association.applied_tp = 0
      association.save
      flash[:notice] = "Item Added Succesfully!"
      redirect_to @character
    end
  end

  def form_params
    params.require(:magicItemSelectForm).permit[:magicItemDropdown]
  end

  def get_item_name(item)
    arr = item.split(" || ")
    return arr[0]
  end

  def get_item_tp(item)
    return item.split(" || ")[1]
  end

end
