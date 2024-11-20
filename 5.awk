BEGIN {
    RS = "\n\n"
    FS = "\n"
    counter = 0
}

# Create the seeds array.
NR == 1 { patsplit($0, seeds, /[0-9]+/) }

# Create mappings, named for the values the mapping produces, not the values the
# mapping uses as a source. In this file, the previous non-comment line contains
# the type of source value that is mapped to a destination value. For example,
# the previous non-comment line creates the seeds array, so the soilmap maps
# seed values to soil values.
NR == 2 { createMapping(soilmap) }
NR == 3 { createMapping(fertilizermap) }
NR == 4 { createMapping(watermap) }
NR == 5 { createMapping(lightmap) }
NR == 6 { createMapping(temperaturemap) }
NR == 7 { createMapping(humiditymap); for(i in humiditymap) print "[DEBUG\tlocationmap] "i "\t" humiditymap[i]  }
NR == 8 { createMapping(locationmap) }

# Create a map using the integers on the current record: the integers are in
# pairs like DST SRC LNG, where DST is the lower, inclusive boundary of the
# range of mapped values; SRC is the lower, inclusive boundary of the values
# mapped; and LNG is the length of the range of values mapped from SRC to DST.
#
# array: is the array to store the mapping in, where source values are the indices
# of the array, and destination values are values of the elements of the array.
function createMapping(array) {
    # print "[DEBUG\tcreateMapping]Count of calls to creatMapping: " ++counter;
    delete arr
    # For each partial mapping,
    for(i = 2; i <= NF; i++) {
        split($i, arr, " ")
        # Store the lower and upper boundaries of the source and destination
        # values; first, store the lower, inclusive boundary; second, store the
        # upper, inclusive boundary.
        array[arr[2]] = arr[1];
        # print "[DEBUG\tcreateMapping] array["arr[2]"] := "array[arr[2]]

        array[arr[2] + arr[3] - 1] = arr[1] + arr[3] - 1;
        # print "[DEBUG\tcreateMapping] array["arr[2] + arr[3] - 1"] := "array[arr[2] + arr[3] - 1]
    }
}

# Map a value, using a mapping array created with createMapping, from a source
# to a destination. The destination value is returned directly, and no array
# modification occurs.
#
# x: a number to check if it is mapped in the values in arrayName
# arr: an array containing one or more pairs of the minimum and maximum bounds
#      of ranges.
function mapValue(x, arr) {
    delete indices

    numberOfElements = asorti(arr, indices)

    if (length(arr) % 2) {
        print "[ERROR 2\tmapValue] Array passed to mapValue has an odd number of elements [the result of asorti(arr, indices):="numberOfElements"]."
        for(z in arr) {
            print "[ERROR 2\tmapValue] arr["z"]:="arr[z]
        }
        exit 2
    }

    # For each partial mapping in the mapping array,
    for (u = 1; u < numberOfElements; u += 2) {
        # determine if the source value x index is in this partial mapping,
        if ((indices[u] <= x) && (x <= indices[u + 1])) {
            # a <= x <= c
            # If x is between or equal to a and c, return the calculated mapped
            # value of x.
            delta = (x - indices[u]) # x and the indices are source values

            # Map the value by returning the lower-bound of the mapped range of
            # values plus the offset.
            return arr[indices[u]] + delta
        }
    }

    if (length(arr) % 2) print "[DEBUG\tmapValue] Returning unmapped value (which theremore maps to itself) map(𝑥) := 𝑥 (" x ")"
    # If no mapping in the mapping array exists for the value x, return the
    # value x, which maps to itself.
    return x
}

END {
    asort(seeds)
    for (i = 1; i <= length(seeds); i++) {
        soils[i] = mapValue(seeds[i], soilmap)
        fertilizers[i] = mapValue(soils[i], fertilizermap)
        waters[i] = mapValue(fertilizers[i], watermap)
        lights[i] = mapValue(waters[i], lightmap)
        temperatures[i] = mapValue(lights[i], temperaturemap)

        # FIXME: supposedly, the error lies within humiditymap!
        humidities[i] = mapValue(temperatures[i], humiditymap)

        locations[i] = mapValue(humidities[i], locationmap)
    }

    if (asort(locations) < asort(seeds)) {
        print "[ERROR 1] Not all mapped values stored correctly."
        exit 1
    }

    print "Part one (nearest location): " locations[1]
}
