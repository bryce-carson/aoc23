BEGIN { FS = ""; }

{
    FS = ""
    s = $0
    gsub("[^[:digit:]]", "")
    one += ($1 $NF)
    $0 = s

    FS = "/[[:space:]]/"
    split("zero one two three four five six seven eight nine", EIX, " ")

    # This solution helped me overcome the "tricks". I had known of the "eightwo"
    # problem, but could not solve all the other cases because I didnt think of
    # them.
    gsub(/oneight/, 18)
    gsub(/twone/, 21)
    gsub(/threeight/, 38)
    gsub(/fiveight/, 58)
    gsub(/sevenine/, 79)
    gsub(/eightwo/, 82)
    gsub(/eighthree/, 83)
    gsub(/nineight/, 98)
    gsub(/zerone/, 01)

    for (j = 1; j < 11; j++)
        gsub(EIX[j], j - 1)

    gsub(/[^0-9]/, "")
    two += ($1 $NF)
}

END {
    print "Part one: " one
    print "Part two: " two
}
