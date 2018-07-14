class SingleLogController < ApplicationController
  before_action :set_character
  include LogHelper
  #
  # form display
  #
  def display()
    render 'characterStandalone/form'
  end

  #
  # log generation controller method
  #
  def generate()
    errors = validate_params(form_params)
    if errors.length < 1
      @logs = buildLogStrings(form_params, @character)
      render 'characterStandalone/logPage'
    else
      errors.each do |error|
        flash[:error] = error
      end
      render 'characterStandalone/form'
    end
  end

  def set_character
    @character = Character.find(params[:id])
  end


  private
  #
  # get sanitized params
  #
  def form_params()
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
  #Gets numeric input, loops until user inputs only an integer value
  def isIntVal(val)
    return /((\d)+)/.match(val) && !/((\d)+\.(\d)+)/.match(val)
  end

  private
  #Gets numeric input, loops until user inputs a float or integer value
  def isNumericVal(val)
    return /((\d)+)/.match(val) || /((\d)+\.(\d)+)/.match(val)
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
  def buildLevelUpString(params, character)
    leveledUp = false
    newLevel = character.level
    totalCP = params[:questCpGained].to_f + character.cp
    while doesLevelUp?(totalCP, newLevel)
      leveledUp = true
      newLevel += 1
      if newLevel > 6
        totalCP -= 8
      else
        totalCP -= 4
      end
    end
    character.cp = totalCP
    character.level = newLevel
    character.gp += params[:questGpGained].to_f
    character.save
    if leveledUp
      return "#{character.name} gains #{params[:questCpGained]} CP from **#{params[:questName]}** and
              levels up to level #{newLevel}!! (#{totalCP}/#{getCpNeeded(newLevel)}
              to level #{newLevel + 1})"
    else
      return "#{character.name} gains #{params[:questCpGained]} CP from **#{params[:questName]}** and
              remains level #{character.level} (#{totalCP}/#{getCpNeeded(character.level)})"
    end
  end

  private
  #
  # Builds a string which describes how much gp was gained on a quest
  #
  def buildGpString(params, character)
    return "#{character.name} also gains #{params[:questGpGained]} GP and
            now has a total of #{character.gp} GP"
  end


end