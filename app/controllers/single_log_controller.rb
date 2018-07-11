class SingleLogController < ApplicationController
  include ApplicationHelper
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
      #build log strings
      @logs = build_log_strings(form_params)
      render 'characterStandalone/logPage'
    else
      #render new and flash errors
      errors.each do |error|
        #this will just display the last error as the flashed error
        flash[:error] = error
        @character = Character.find(params[:id])
        render 'characterStandalone/form'
      end
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
  def build_log_strings(params)
    strings = []
    strings << "Log Strings gona go here"
    return strings
  end
end