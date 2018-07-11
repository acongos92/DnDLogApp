module ApplicationHelper
  #This method is made so that a user can input all of their character
  #information and their logs shall be automatically made for them.
  #
  #author vict0rem


#These defs are made to determine the amount of CP a character needs to level
#up and if they did level up how much CP they will need for their next level.
  def CP(level)
    cpNeeded = 0
    if level > 0 && level <= 5
      cpNeeded + 4
    elsif level > 5 && level <= 20
      cpNeeded + 8
    else
      cpNeeded + 0
    end
  end

  def CP2(level)
    cpNeeded = 0
    level + 1
    if level > 0 && level <= 5
      cpNeeded + 4
    elsif level > 5 && level <= 20
      cpNeeded + 8
    else
      cpNeeded + 0
    end
  end

#This is all the information the program needs from the user in order to
#create their logs and do all of the necessary calculations.
  def getLogStrings(name, level, race, classes, quest, cpNow,
                    tpItem, tpNow, tpNeeded, gpNow, cpGained,
                    tpGained, gpGained, itemsBought, itemsBpPrice,
                    itemsSold, itemsSPrice)
    level = level.to_i
    cpNow = cpNow.to_f
    tpNow = tpNow.to_f
    tpNeeded = tpNeeded.to_i
    gpNow = gpNow.to_f
    cpGained = cpGained.to_f
    tpGained = tpGained.to_f
    gpGained = gpGained.to_f
    cpTotal = cpNow + cpGained
    tpTotal = tpNow + tpGained
    gpTotal = gpNow + gpGained
    cpNeeded2 = 0
    tpItem2 = 0
    tpNeeded2 = 0

    if cpTotal > CP(level)
      level = level
      cpNeeded = CP2(level)
      level = level + 1
    else
      cpNeeded = CP(level)
    end

    #This if-else statement checks to see if the user's character receives their
    #current magical item. If they do then they must choose their next magical
    #item and enter how much TP it neeeds and if they don't then there is no next
    #magical item for them to input.
    if tpTotal > tpNeeded
      tpNow = tpTotal - tpNeeded
      puts "Enter the name of your next magical item: "
      tpItem2 = gets.chomp
      puts "Enter the total amount of TP needed for this magical item: "
      tpNeeded2 = getIntegerInput
      tpNeeded2 = tpNeeded2.to_i
    else
      puts "152"
      tpItem2 = "N/A"
      tpNeeded2 = 0
    end

  #This section is to check if the user's character would like to buy or sell
  #anything and gets the user to input the prices for the various items.
    puts "Are you buying any items (Y or N)? "
    buying = gets.chomp
    if buying.downcase == "y"
      puts "What item(s) are you buying? "
      itemsBought = gets.chomp
      puts "What is the total cost of these items? "
      itemsBPrice = getFloatInput
      itemsBPrice = itemsBPrice.to_f
      gpTotal = gpTotal - itemsBPrice
    else
      itemsBought ="N/A"
      itemsBPrice = 0
    end

    puts "Are you selling any items (Y or N)? "
    selling = gets.chomp
    if selling.downcase == "y"
      puts "What item(s) are you selling? "
      itemsSold = gets.chomp
      puts "What is the total cost of these items? "
      itemsSPrice = getFloatInput
      itemsSPrice = itemsSPrice.to_f
      gpTotal = gpTotal + itemsSPrice
    else
      itemsSold = "N/A"
      itemsSPrice = 0
    end

    puts ""
    puts ""

  #These calcualtions are made before producing the strings
    levelAddOne = level + 1
    levelAddTwo = level + 2
    cp2 = CP2(level)
    cpTotal2 = cpTotal - cpNeeded
    cp = CP(level)

    gpTotalBuy = gpTotal - itemsBPrice
    gpTotalSell = gpTotal + itemsSPrice
    gpTotalBoth = gpTotal + itemsSPrice - itemsBPrice

    creation = "Creating #{name}, Level #{level} #{race} #{classes}"
    death = "**DEATH:** #{name} has fallen in battle during **#{quest}**."
    nearDeath = "#{name} dodged death and receives no rewards from **#{quest}**."
    info = [creation, death, nearDeath]

    levelUp = "#{name} gains #{cpGained} CP from **#{quest}** and levels up to level #{levelAddOne} (#{cpTotal2}/#{cp2} CP to level #{levelAddTwo}).\n"
    noLevelUp = "#{name} gains #{cpGained} CP from **#{quest}** (#{cpTotal}/#{cp} to level #{levelAddOne})."
    cpLogs = [levelUp, noLevelUp]

    tpItemGet = "#{name} gains #{tpGained} TP and #{gpGained} GP from **#{quest}** and puts the TP towards **#{tpItem}** completing it and puts the rest of their TP into **#{tpItem2}** (#{tpNow}/#{tpNeeded2}) and has a total of #{gpTotal} GP."
    tpItemNotGet = "#{name} gains #{tpGained} TP and #{gpGained} GP from **#{quest}** and puts the TP towards **#{tpItem}** (#{tpNow}/#{tpNeeded}) and has a total of #{gpTotal} GP."
    tpLogs = [tpItemGet, tpItemNotGet]

    buyingStuff = "#{name} buys #{itemsBought} for #{itemsBPrice} GP. #{name} now has #{gpTotalBuy} GP."
    sellingStuff = "#{name} sells #{itemsSold} for #{itemsSPrice} GP. #{name} now has #{gpTotalSell} GP."
    bothStuff = "#{name} buys #{itemsBought} for #{itemsBPrice} GP and sells #{itemsSold} for #{itemsSPrice} GP. #{name} now has #{gpTotalBoth} GP."
    purchaseLogs = [buyingStuff, sellingStuff, bothStuff]

  #Everything after this point calls upon the previously made strings in the
  #previously made arrays to print out all of the information a user could need.
    puts "Character Information (announced in #character-logs)"
    print "Creation:     "
    puts info[0]
    print "Death:      "
    puts info[1]
    print "Near-Death Experience:      "
    puts info[2]

    puts ()

    puts "Leveling (announced in #character-logs)"
    print "Gaining CP/Leveling Up:      "
    if cpTotal > cpNeeded
      cpTotal = cpTotal - cpNeeded
      puts cpLogs[0]
    else
      puts cpLogs[1]
    end

    puts ()

    puts "Currency & Items (announced in #purchase-logs)"
    print "Gaining TP and GP:     "
    if tpTotal > tpNeeded
      puts tpLogs[0]
    else
      puts tpLogs[1]
    end

    print "Buying Items:      "
    puts purchaseLogs[0]
    print "Selling Items:     "
    puts purchaseLogs[1]
    print "Buying and Selling Items:      "
    puts purchaseLogs[2]

    puts ()
    puts ()
    puts ()
    puts ()
    puts "Thanks for using my program! Have a great time, #{name}! - vict0rem"
  end

end
