module LogHelper

  #
  # gets cp needed for next level
  #
  def getCpNeeded(level)
    if level < 5
      needed = 4
    elsif level >= 5
      needed = 8
    else
      needed = nil
    end
    return needed
  end

  #
  # Checks if a character has leveled up based on current level, gained cp, and current cp
  #
  def doesLevelUp?(current, level)
    needed = getCpNeeded(level)
    return (current) >= needed
  end

end