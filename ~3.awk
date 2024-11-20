BEGIN { RS = "" }

{
    FS = /\n/
    lineWidth = length($1)

    while(match($0, /[[:digit:]]+/, number)) {
        # If any symbol index is set,
        if(setSymbolIndices(RSTART, RLENGTH, symbolIndices)) {
            partNumberSum += number[0] # Summate the part number, and add it to
            # the list of part numbers adjacent stars, if it's a star.
            listNumbersAdjacentSymbols(symbolIndices, number[0], maybeGearArray)
        }
        sub(/[[:digit:]]+/, gensub(/[[:digit:]]/, ".", "global", number[0]))
    }

    for(i in maybeGearArray) {
        if(asort(maybeGearArray[i]) == 2) {
            gearRatioSum += (maybeGearArray[1] * maybeGearArray[2])
        }
    }

    print "(Part one) Sum of part numbers: " partNumberSum
    print "(Part two) Sum of gear ratios: " gearRatioSum
}

# The indices set in the array symIdxArray are those which are leftmost (per match).
function setSymbolIndices(numStart, numLength, symIdxArray) {
    regex = "[^.0-9[:space:]]+"
    adjustedLength = numLength + ((numStart == 1) ? 1 : 2)

    matchedp[1] = match(substr($0, numStart - lineWidth - 2, adjustedLength), regex, tmp)
    idx[1] = matchedp[1] + numStart - 1
    symIdxArray[idx[1]] = tmp[0]
    print "[DEBUG] Symbol: " tmp[0] " Index: " idx[1]
    if(tmp[0] ~ "*") debugStarArray[asort(debugStarArray)] = idx[1]

    matchedp[2] = match(substr($0, numStart - 1, adjustedLength), regex, tmp)
    idx[2] = matchedp[2] + numStart - 1
    symIdxArray[idx[2]] = tmp[0]
    print "[DEBUG] Symbol: " tmp[0] " Index: " idx[2]
    if(tmp[0] ~ "*") debugStarArray[asort(debugStarArray)] = idx[2]

    matchedp[3] = match(substr($0, numStart + lineWidth, numLength + 2), regex, tmp)
    idx[3] = matchedp[3] + numStart - 1
    symIdxArray[idx[3]] = tmp[0]
    print "[DEBUG] Symbol: " tmp[0] " Index: " idx[3]
    if(tmp[0] ~ "*") debugStarArray[asort(debugStarArray)] = idx[3]

    return(or(matchedp[1], matchedp[2], matchedp[3]))
}

function listNumbersAdjacentSymbols(symIdxArray, number, maybeGearArray) {
    for(i in symIdxArray) {
        if (symIdxArray[i] ~ "*") {
            maybeGearArray[i][length(maybeGearArray[i]) + 1] = number
        }
    }
}
