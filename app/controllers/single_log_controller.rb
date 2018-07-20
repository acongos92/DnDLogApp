class SingleLogController < ApplicationController
  before_action :set_character
  before_action :set_quest, only: [:generate, :add_magic_item_during_level_up, :add_tp_to_magic_itm,
                                   :show_magic_item_tp_addition, :add_magic_item_during_level_up, :post_magic_item_during_level_up]
  before_action :set_magic_items, only:[:show_magic_item_tp_addition, :add_tp_to_magic_item, :generate]
  before_filter :set_cache_headers, only:[:post_magic_item_during_level_up, :generate, :validate_and_save_quest]

  include LogHelper
  #
  # form display
  #
  def display()
    @quest = Quest.new
    render 'characterStandalone/form'
  end

  #
  # checks validity of quest and saves, or displays errors to user
  #
  def validate_and_save_quest
    @quest = Quest.new(form_params)
    if @quest.save && tp_in_range(@quest)
      set_quest_params(@quest)
      redirect_to action: :show_magic_item_tp_addition, id: @character.id, quest: @quest.id
    else
      @errors = @quest.errors
      flash[:notice] = "cp value cannot exceed tp"
      render 'characterStandalone/form'
    end
  end

  def tp_in_range(quest)
    return quest.tp.to_f <= quest.cp.to_f
  end
  #
  # handles adding new magic item to character during quest logs
  #
  def add_magic_item_during_level_up
    @magic_items = MagicItem.all
    render 'characterStandalone/add_magic_item_during_level_up'
  end

  def post_magic_item_during_level_up
    @magic_item = MagicItem.where(name: get_item_name(params[:magic_item]))[0]
    if @magic_item.nil?
      flash[:error] = "Please use one of the autofill options"
      @magic_items = MagicItem.all
      render 'characterStandalone/add_magic_item_during_level_up'
    else
      @character = Character.find(params[:id])
      association = CharacterMagicItem.new
      association.character_id = params[:id]
      association.magic_item_id = @magic_item.id
      association.applied_tp = 0
      association.save
      flash[:notice] = "Item Added Succesfully!"
      redirect_to action: :show_magic_item_tp_addition, id: @character.id, quest: @quest.id
    end
  end

  #
  # shows magic items to which tp can be added
  #
  def show_magic_item_tp_addition
    @character_magic_items = @character.character_magic_items
    render 'characterStandalone/add_tp_to_magic_item'
  end
  #
  # log generation controller method
  #
  def generate
    @character_magic_items = @character.character_magic_items
    errors = validate_magic_item_params(params, @character_magic_items)
    spent_too_much_tp = getTpErrors(@quest, getTotalTp(params, @character_magic_items))
    if errors.empty? && spent_too_much_tp.nil?
      @logs = buildLogStrings(@quest, @character, params, @character_magic_items)
      render 'characterStandalone/logPage'
    else
      spent_too_much_tp.nil? ? flash[:error] = errors[0] : flash[:error] = spent_too_much_tp
      render 'characterStandalone/add_tp_to_magic_item'
    end

  end

  def set_character
    @character = Character.find(params[:id])
  end

  def set_quest
    @quest = Quest.find(params[:quest])
  end

  def set_magic_items
    @magic_items = @character.magic_items
  end

  def set_quest_params(questModel)
    questModel.tp = form_params[:tp].to_f
    questModel.cp = form_params[:cp].to_f
    questModel.name = form_params[:name]
    questModel.gp = form_params[:gp].to_f
  end


  private
  #
  # get sanitized params
  #
  def form_params
    params.require(:quest).permit(:name, :cp, :tp, :gp)
  end


  private
  #
  # Checks validity of magic item update params
  #
  def validate_magic_item_params(params, magicItems)
    errors = []
    magicItems.each do |item|
      if item.applied_tp < item.magic_item.tp
        unless isNumericVal params[:finish_quest_input][item.magic_item.name]
          errors << "Input tp increase must be numeric"
        end
      end
    end
    return errors
  end

  private
  # checks if input value is strictly an integer
  def isIntVal(val)
    /((\d)+)/.match(val) && !/((\d)+\.(\d)+)/.match(val)
  end

  private
  # checks if input value is numeric either float or integer
  def isNumericVal(val)
    /((\d)+)/.match(val) || /((\d)+\.(\d)+)/.match(val)
  end

  private
  #
  # builds and returns an array of log strings to be output
  #
  def buildLogStrings(quest, character, params, character_magic_items)
    strings = []
    strings << buildLevelUpString(quest, character)
    buildTpLogStrings(params, character_magic_items, strings, character.name, quest)
    strings << buildGpString(quest, character)
    return strings
  end

  private
  #
  # Builds and return a string which describes how cp gained on a quest will affect character level
  # updates character model to reflect these logs
  #
  def buildLevelUpString(quest, character)
    leveledUp = false
    newLevel = character.level
    totalCP = quest.cp + character.cp
    if character.level < 20
      while doesLevelUp?(totalCP, newLevel)
        leveledUp = true
        newLevel += 1
        if newLevel > 6
          totalCP -= 8
        else
          totalCP -= 4
        end
      end
      updateCharacterWithQuest(quest, character, totalCP, newLevel)
      if leveledUp
        if newLevel < 20
          return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and
                  levels up to level #{newLevel}!! (#{totalCP}/#{getCpNeeded(newLevel)}
                  to level #{newLevel + 1})"
        else
          return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and
                  levels up to level #{newLevel}!!"
        end
      else
        return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and
                remains level #{character.level} (#{totalCP}/#{getCpNeeded(character.level)})"
      end
    else
      updateCharacterWithQuest(quest, character, 0, newLevel)
      return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and and is level 20"
    end
  end

  #
  # Builds a string which describes how much gp was gained on a quest
  #
  def buildGpString(quest, character)
    return "#{character.name} also gains #{quest.gp} GP and
            now has a total of #{character.gp} GP"
  end

  #
  # builds tp related strings and updates character_magic_items model
  #
  def buildTpLogStrings(params, characterMagicItems, logs, characterName, quest)

      logString = "#{characterName} also gains #{quest.tp} TP from #{quest.name} and puts it toward "
      characterMagicItems.each do |item|
        if item.applied_tp < item.magic_item.tp
          magicItem = MagicItem.find(item.magic_item_id)
          addedTp = params[:finish_quest_input][magicItem.name].to_f
          currentTp = item.applied_tp
          neededTp = magicItem.tp
          if addedTp > 0.0
            currentTp += addedTp
            if currentTp >= neededTp
              logString = logString + generateItemFinishedLog(magicItem, addedTp, neededTp)
              item.applied_tp = currentTp
              item.save
            else
              item.applied_tp = currentTp
              item.save
              logString = logString +  generateItemPartiallyFinishedLog(magicItem, addedTp, currentTp, neededTp)
            end
          end
        end
      end
       logs << logString
  end

  #
  # generates a log to reflect that an item has been completed by the characted
  # completed defined as applying an amount of tp equal or greater than required tp
  #
  def generateItemFinishedLog(item, addedTp, neededTp)
    "#{item.name} (#{neededTp}/#{neededTp}) and completes the item! "
  end

  #
  # generates a log to reflect an item had tp applied, but that item was not completed
  #
  def generateItemPartiallyFinishedLog(item, addedTp, totalTp, neededTp)
    "#{item.name} (#{totalTp}/#{neededTp}) "
  end
  # Updates a and saves a character model to reflect quest values
  #
  def updateCharacterWithQuest(quest, character, totalCP, newLevel)
    character.cp = totalCP
    character.level = newLevel
    character.gp += quest.gp
    character.save
  end

  #
  # returns an error if total TP exceeds quest tp
  #
  def getTpErrors(quest, totalTp)
    error = nil
    unless quest.tp >= (totalTp - 0.1)
      error = "Added tp cannot exceed tp gained on quest"
    end

    if totalTp <= quest.tp - 0.1
      error = "you must spend all tp"
    end
    return error
  end

  #
  # returns total tp based on form input
  #
  def getTotalTp(params, characterMagicItems)
    total = 0
    characterMagicItems.each do |item|
      if item.applied_tp < item.magic_item.tp
        total += params[:finish_quest_input][item.magic_item.name].to_f
      end
    end
    return total
  end

  def get_item_name(item)
    arr = item.split(" || ")
    return arr[0]
  end

  def get_item_tp(item)
    return item.split(" || ")[1]
  end

end