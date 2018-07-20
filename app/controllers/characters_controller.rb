class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all.order(:name)
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    @items = @character.character_items
    @magicItems = @character.magic_items
    @character_magic_items = @character.character_magic_items

  end

  def remove_owned_magic_item
    item = CharacterMagicItem.find(params[:id])
    character = Character.find(item.character_id)
    item.destroy
    flash[:notice] = "Item Removed"
    redirect_to character
  end

  def remove_owned_item
    item = CharacterItem.find(params[:id])
    character = Character.find(item.character_id)
    item.destroy
    flash[:notice] = "Item Removed"
    redirect_to character
  end
  # GET /characters/new
  def new
    @character = Character.new
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.json
  def create
    @character = Character.new(character_params)
    respond_to do |format|
      if @character.valid? && is_in_level_range?(@character)
        @character.save
        format.html { redirect_to @character, notice: 'Character was successfully created.' }
        format.json { render :show, status: :created, location: @character }
      else
        if @character.valid?
          flash[:error] = "Max CP for a level 4 or below character is 3" unless is_in_level_range?(@character)
        end
        format.html { render :new }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy
    respond_to do |format|
      flash[:notice] = "Character was removed"
      format.html { redirect_to characters_url }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_params
      params.require(:character).permit(:name, :race, :level, :cp, :gp)
    end

  def is_in_level_range? (character)
    range = true
    if character.level < 5
      range = character.cp < 4
    end
    return range
  end
end
