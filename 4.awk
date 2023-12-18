{
    delete list
    delete win
    delete game
    delete played
    points = 0
    cardPoints = 0

    sub("Card +[[:digit:]]+:", "")
    split($0, list, "|")
    patsplit(list[1], win, "[[:digit:]]+")
    patsplit(list[2], game, "[[:digit:]]+")

    # For every number in the game number array, convert the values into indices in a new array.
    for(i in game) played[game[i]] = game[i]

    # For every winning number, check if that number is an index in the played array.
    for(i in win) if(win[i] in played) ++points

    cardPoints += 2^(points - 1)
    if(cardPoints >= 1) totalPoints += cardPoints

    do {
        for(i = 1; i <= points; i++) arr[NR + i] += 1
        arr[NR] -= 1
        totalScratchCards += 1
    } while(arr[NR] >= 0)
}

END {
    print "Part one: " totalPoints
    print "Number of scratch cards: " totalScratchCards
}
