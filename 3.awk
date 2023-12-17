# github.com/bryce-carson
# The identifier of functions which change the match data begin with _

BEGIN { RS = ""; FS = "\n"; }

{
    # FS = "\n"
    lineWidth = length($1)
    gsub("\n", "", $0)
    total = length($0)

    # Delcare arrays, use them then delete the null-index element before later
    # iteration.
    nArr[init]; _indices(nArr, "[0-9]+"); delete nArr[init]
    sArr[init]; _indices(sArr, "[^.0-9]"); delete sArr[init]

    # DONE: TEST: test that the object arrays are working.
    # for(i in nArr) { # For every array (pseudo-object) within nArr,
    #     print ""
    #     for(j = 0; j < 7; j++) # Access the fields of the array (pseudo-object)
    #         print nArr[i][j];
    # }

    for(idx in sArr) if(sArr[idx] ~ "*") starArray[++idx]
    for(idx in starArray) {
        # Reset the counter
        counter = 0

        # For each index, search for numbers in the appropriate area of the star.
        # If two results are found, then do the thing?
        if(match($0, /[[:digit:]+]/, tmp)) partNumber[++counter] = tmp[0]
        if(counter == 2) gearRatioSum += partNumber[1] * partNumber[2]

        for(i in partNumber) partNumberSum += partNumber[i]
    }

    print "(Part one) Sum of part numbers: " partNumberSum
    print "(Part two) Sum of gear ratios: " gearRatioSum
}

# Search the input string from the beginning for re using match, jumping to the
# next reasonable position when a match is found; substitute matches for the
# grid background character.
function _indices(arr, re) {
    for(i = 1; i <= length($0);) {
        # Advance point to after the current match
        if(!match(substr($0, i, length($0) - i + 1), re, num)) break;

        arr[RSTART][0] = num[0]
        i = RSTART + RLENGTH + 1 # Advance the pointer

        bounds(RSTART, RSTART + RLENGTH - 1, arr)
        sub(re, repeat(".", RLENGTH), $0)
    }
}

# DONE: TEST: repeat
# { result = repeat(6, 3); print result; }
function repeat(what, size) {
    string = ""
    for(i = 0; i < size; i++) string = string ("" what) # Force string conversion for safety.
    return string
}

# ss: RSTART
# se: RSTART + RLENGTH - 1
# objarr: an array which is used to store the index of the object's position in
#         the field, and the object's fields within a subarray.
function bounds(ss, se, objarr) {
    # Left and right
    l = (ss - 1)
    objarr[ss][3] = (l >= 1) ? l : ss
    r = (se + 1)
    objarr[ss][4] = (r <= total) ? r : se

    # Top left and top right
    tl = (ss - lineWidth - 1)
    objarr[ss][1] = (tl >= 1) ? tl : objarr[ss][3]
    tr = (se - lineWidth + 1)
    objarr[ss][2] = ((tr <= total) && (tr >= 1)) ? tr : objarr[ss][4]

    # Bottom left and bottom right
    bl = (ss + lineWidth - 1)
    objarr[ss][5] = ((bl >= 1) && (bl <= total)) ? bl : objarr[ss][3]
    br = (se + lineWidth + 1)
    objarr[ss][6] = (br <= total) ? br : objarr[ss][4]
}
