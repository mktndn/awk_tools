#
#	count and add footnote.
#
BEGIN {
    NOTE = "†";					# digraph /-
    cnt = 0;
}

{
    out = "";					# output buffer.
    numFrags = split($0, fragments, NOTE);	# returns zero on no match.
    i = 1;
    for (; i<numFrags; ++i) {
	cnt++;
	out = out fragments[i] sprintf("[†%d] ", cnt);
    }
    out = out fragments[i]			# the last fragment or original $0.
    print out;
}

END {
    if (cnt > 0) {
	print("----");
    }
    for (i=1; i<=cnt; ++i) {
	print sprintf(" [†%d] ", i) ": ";
    }
}

