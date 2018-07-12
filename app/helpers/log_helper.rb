module LogHelper

  #
  # gets cp needed for next level
  #
  def getCpNeeded(level)
    if level <= 5
      needed = 4 * level
    elsif level > 5
      needed = 20 + (8 * (level - 5))
    else
      needed = nil
    end
    return needed
  end

  #
  # Checks if a character has leveled up based on current level, gained cp, and current cp
  #
  def doesLevelUp?(gained, current, level)
    needed = getCpNeeded(level)
    return (gained + current) >= needed
  end

end