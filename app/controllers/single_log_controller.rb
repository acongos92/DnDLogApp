class SingleLogController < ApplicationController
  include LogHelper
  #
  # form display
  #
  def display()
    @character = Character.find(params[:id])
    render 'characterStandalone/form'
  end

  #
  # log generation controller method
  #
  def generate()
    errors = validate_params(form_params)
    if errors.length < 1
      @character = Character.find(params[:id])
      @logs = buildLogStrings(form_params, @character)
      updateCharacter(form_params, @character)
      render 'characterStandalone/logPage'
    else
      errors.each do |error|
        flash[:error] = error
        @character = Character.find(params[:id])
      end
      render 'characterStandalone/form'
    end
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
  #
  def buildLevelUpString(params, character)
    leveledUp = false
    newLevel = character.level
    while doesLevelUp?(params[:questCpGained].to_f, character.cp, newLevel)
      leveledUp = true
      newLevel += 1
    end
    if leveledUp
      return "#{character.name} gains #{params[:questCpGained]} CP from #{params[:questName]} and
              levels up to level #{newLevel}!! (#{character.cp + params[:questCpGained].to_f}/#{getCpNeeded(newLevel + 1)}
              to level #{newLevel + 1})"
    else
      return "#{character.name} gains #{params[:questCpGained]} CP from #{params[:questName]} and
              remains level #{character.level} (#{character.cp + params[:questCpGained].to_f}/#{getCpNeeded(character.level + 1)}
              to level #{character.level + 1})"
    end
  end

  private
  #
  # Builds a string which describes how much gp was gained on a quest
  #
  def buildGpString(params, character)
    return "#{character.name} also gains #{params[:questGpGained]} GP, and
            now has a total of #{character.gp + params[:questGpGained].to_f} GP"
  end
  private
  #
  # Updates a characters information stored in database
  #
  def updateCharacter(params, character)
    while doesLevelUp?(params[:questCpGained].to_f, character.cp, character.level)
      character.level += 1
    end
    character.gp += params[:questGpGained].to_f
    character.cp += params[:questCpGained].to_f
    character.save
  end


end