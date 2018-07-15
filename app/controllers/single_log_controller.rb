class SingleLogController < ApplicationController
  before_action :set_character
  before_action :set_quest, only: [:generate]
  before_action :set_magic_items, only:[:show_magic_item_tp_addition_form, :add_tp_to_magic_item]

  include LogHelper
  #
  # form display
  #
  def display()
    render 'characterStandalone/form'
  end

  #
  # checks validity of quest and saves, or displays errors to user
  #
  def validate_and_save_quest
    errors = validate_params(form_params)
    if errors.empty?
      quest = Quest.new
      set_quest_params(quest)
      quest.save
      redirect_to action: :generate, id: @character.id, quest: quest.id
    else
      errors.each do |error|
        flash[:error] = error
      end
      render 'characterStandalone/form'
    end
  end

  #
  # handles adding new magic item to character during quest logs
  #
  def add_magic_item_during_level_up

  end
  
  #
  # handles post request logic around tp addition to magic item
  #
  def add_tp_to_magic_item

  end

  #
  # shows magic items to which tp can be added
  #
  def show_magic_item_tp_addition_form

  end
  #
  # log generation controller method
  #
  def generate
    @logs = buildLogStrings(@quest, @character)
    render 'characterStandalone/logPage'
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

  def set_quest_params (questModel)
    questModel.tp = form_params[:questTpGained].to_f
    questModel.cp = form_params[:questCpGained].to_f
    questModel.name = form_params[:questName]
    questModel.gp = form_params[:questGpGained].to_f
  end


  private
  #
  # get sanitized params
  #
  def form_params
    params.require(:generate_log).permit(:questName, :questCpGained, :questTpGained, :questGpGained)
  end

  private
  #
  # checks validity of parameter input, assumes all are present
  #
  def validate_params(params)
    errors = []
    if !isNumericVal(params[:questCpGained])
      errors << "quest cp gained needed should be numeric value"
    elsif !isNumericVal(params[:questTpGained])
      errors << "quest tp gained needed should be numeric value"
    elsif !isNumericVal(params[:questGpGained])
      errors << "quest gp gained needed should be numeric value"
    end
    return errors
  end

  private
  # Gets numeric input, loops until user inputs only an integer value
  def isIntVal(val)
    /((\d)+)/.match(val) && !/((\d)+\.(\d)+)/.match(val)
  end

  private
  # Gets numeric input, loops until user inputs a float or integer value
  def isNumericVal(val)
    /((\d)+)/.match(val) || /((\d)+\.(\d)+)/.match(val)
  end

  private
  #
  # builds and returns an array of log strings to be output
  #
  def buildLogStrings(params, character)
    strings = []
    strings << buildLevelUpString(params, character)
    strings << buildGpString(params, character)
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
    totalCP = quest.tp + character.cp
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
      return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and
              levels up to level #{newLevel}!! (#{totalCP}/#{getCpNeeded(newLevel)}
              to level #{newLevel + 1})"
    else
      return "#{character.name} gains #{quest.cp} CP from **#{quest.name}** and
              remains level #{character.level} (#{totalCP}/#{getCpNeeded(character.level)})"
    end
  end

  private
  #
  # Builds a string which describes how much gp was gained on a quest
  #
  def buildGpString(quest, character)
    return "#{character.name} also gains #{quest.gp} GP and
            now has a total of #{character.gp} GP"
  end

  private
  #
  # Updates a and saves a character model to reflect quest values
  #
  def updateCharacterWithQuest(quest, character, totalCP, newLevel)
    character.cp = totalCP
    character.level = newLevel
    character.gp += quest.gp
    character.save
  end


end