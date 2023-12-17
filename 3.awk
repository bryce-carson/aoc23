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

    for(i in nArr) {
        print ""
        for(j in nArr[i])
            print nArr[i][j]
    }

    # For each number, determine if it is a part number. If it is not, delete the
    # number from the array.
    for(idx in nArr) {
        print substr($0, nArr[idx][1], nArr[idx][2] - (nArr[idx][1] - 1))
        print substr($0, nArr[idx][3], nArr[idx][4] - (nArr[idx][3] - 1))
        print substr($0, nArr[idx][5], nArr[idx][6] - (nArr[idx][5] - 1))

        t = match(substr($0, nArr[idx][1], nArr[idx][2] - (nArr[idx][1] - 1)), syms)
        m = match(substr($0, nArr[idx][3], nArr[idx][4] - (nArr[idx][3] - 1)), syms)
        b = match(substr($0, nArr[idx][5], nArr[idx][6] - (nArr[idx][5] - 1)), syms)

        if(or(t, m, b)) partNumberSum += nArr[idx][0]
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
                    if(i == pos) maybeGears[pos][++counter] = nArr[idx][0]

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
    for(i = 1;
        i <= length($0) && match(substr($0, i), re, num);
        # NOTE: Iterate based on the whether the regular expression is nums or
        # not. When matching nums, advance point further; when matching syms,
        # only advance point by one.
        #
        # NOTE:_rstart is an adjusted start to overcome the scanning through
        # substrings. It maintains an adjusted RSTART such that _rstart is where
        # the match begins in $0, rather than RSTART which is the index the
        # match occurs at in the substring in each iteration.
        i += ((re == nums) ? _rstart + RLENGTH : 1))
    {
        _rstart = RSTART + i - 1
        arr[_rstart][0] = num[0]
        bounds(_rstart, _rstart + RLENGTH - 1, arr)
    }
}

function repeat(what, size) {
    str = ""
    for(i = 0; i < size; i++) str = str ("" what) # Force str conversion for safety.
    return str
}

# ss: _rstart
# se: _rstart + RLENGTH - 1
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
