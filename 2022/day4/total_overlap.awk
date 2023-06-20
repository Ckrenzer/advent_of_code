#!/usr/bin/awk -f

BEGIN{
    FS = ","
}

{
    split($1, range1, "-")
    split($2, range2, "-")
    min_elf1 = range1[1]
    max_elf1 = range1[2]
    min_elf2 = range2[1]
    max_elf2 = range2[2]
    overlaps += (min_elf1 >= min_elf2 && max_elf1 <= max_elf2) || (min_elf2 >= min_elf1 && max_elf2 <= max_elf1)
}

END{
    print "The number of complete overlaps:", overlaps
}
