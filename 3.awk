# github.com/bryce-carson
# The identifier of functions which change the match data begin with _

BEGIN { RS = "" }

{
    FS = "\n"
    lineWidth = length($1)
    gsub("\n", "", $0)
    total = length($0)
    nums = "[0-9]+"
    syms = "[^.0-9]"

    # Delcare arrays, use them then delete the null-index element before later
    # iteration.
    nArr[init]; _indices(nArr, nums); delete nArr[init]
    sArr[init]; _indices(sArr, syms); delete sArr[init]

    # DEBUG
    # for(i in nArr)
    #     for(j in nArr[i])
    #         print nArr[i][j]

    # For each number, determine if it is a part number. If it is not, delete the
    # number from the array.
    for(idx in nArr) {
        l = nArr[idx][2] - (nArr[idx][1] - 1)

        # DEBUG
        if(l < 1) exit(1)

        s1 = substr($0, nArr[idx][1], l)
        s2 = substr($0, nArr[idx][3], l)
        s3 = substr($0, nArr[idx][5], l)

        print nArr[idx][1] "\t" s1
        print nArr[idx][3] "\t" s2
        print nArr[idx][5] "\t" s3

        t = match(s1, syms)
        m = match(s2, syms)
        b = match(s3, syms)

        print nArr[idx][0] " is a part number?\t" or(t, m, b)

        if(or(t, m, b)) partNumberSum += nArr[idx]
        else delete nArr[idx]
    }

    print "(Part one) Sum of part numbers: " partNumberSum

    # Delete the element of the array if it's not a star.
    for(idx in sArr) if(!( sArr[idx][0] ~ "*" )) delete starArray[idx]

    # Determine if each star is potentially a gear:
    # For each index 𝑖𝑑𝑥 test if the number at 𝑖𝑑𝑥 is in the appropriate area of the
    # star.
    for(pos in sArr) {
        # Reset the counter and the arrays in the beginning of each iteration.
        delete maybeGears
        counter = 0
        delete partNumber

        for(idx in nArr)
            for(subidx = 1; subidx < 6; subidx += 2)
                for(i = nArr[idx][subidx]; i <= nArr[idx][subidx + 1]; i++)
                    if(i == pos) maybeGears[pos][++counter] = nArr[idx]

        # If exactly two part numbers are found for a given star, the star is
        # actually a gear and the ratio (product) of the part numbers is added to the
        # gearRatioSum.
        if(counter == 2) gearRatioSum += maybeGears[pos][1] * maybeGears[pos][1]
    }

    print "(Part two) Sum of gear ratios: " gearRatioSum
}

# Search the input string from the beginning for re using match, jumping to the
# next reasonable position when a match is found; substitute matches for the
# grid background character.
# arr: The object array to use.
# re: the regular expression to use to construct objects.
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
