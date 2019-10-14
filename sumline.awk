#
#
BEGIN {
    FS = " "
}

/.*/ {
    for (sum=i=0; i<=NF; ++i) {
	sum += $i;
    }
    if (sum > 0)
	print ($0 "\t:" sum)
    else
	print $0
    }

END {
}

