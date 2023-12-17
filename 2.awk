# Games are possible if: red <= 12 && green <= 13 && blue <= 14
# Summate the line numbers, which are equivalent to game IDs:
# Summation of line numbers borrowed from https://github.com/xiaowuc1/aoc-2023-kotlin/blob/main/src/Day02.kt; it's more reliable than parsing the integer in arr[0].
# Above solution was viewed after my algorithm was established, but program was not running correctly.
{
    split($0, arr, /[,:;]/)

    delete redArr # Delete the arrays used in the previous iteration.
    delete greenArr
    delete blueArr

    ridx = 0;
    gidx = 0;
    bidx = 0;

    # To store each count of cubes of a colour,
    for(i in arr) {
        match(arr[i], "[[:digit:]]+", tmp) # Match is stored in tmp[0]
        if (arr[i] ~ "red") redArr[ridx++] = tmp[0]
        else if (arr[i] ~ "green") greenArr[gidx++] = tmp[0]
        else if (arr[i] ~ "blue") blueArr[bidx++] = tmp[0]
    }

    # Summate the possible games.
    if(and(arrmax(redArr, 12), arrmax(greenArr, 13), arrmax(blueArr, 14))) {
        partOneSum += FNR
    }

    # Summate the power of the minimal set of cubes of each game.
    partTwoSum += (arrmax(redArr) * arrmax(greenArr) * arrmax(blueArr))
}

END {
    print("Part one: " partOneSum);
    print("Part two: " partTwoSum);
}

# arrmax(a) := max(a)
# arrmax(a,b) := arrmax(a) <= b
function arrmax(array, maximum, max) {
    for(i in array) if(array[i] > max) max = array[i]
    return (typeof(maximum) == "number") ? (max <= maximum) : max;
}

#Input example starts immediately following the pound sign.
#Game 1: 1 green, 2 blue; 15 blue, 12 red, 2 green; 4 red, 6 blue; 10 blue, 8 red; 3 red, 12 blue; 1 green, 12 red, 8 blue
#      ↑        ↑       ↑        ↑       ↑        ↑      ↑       ↑        ↑      ↑      ↑        ↑        ↑       ↑
#arr[1]|  arr[2]| arr[3]|
