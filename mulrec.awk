#!/bin/gawk
#	mulrec.awk
#	1レコードが複数行にまたがる場合、間にTABを入れて1行にする
#
BEGIN {
    if (rlen == "") {
	rlen = 2;	# 1レコードの行数
    }
    out = "";
}

/.*/ {
    if (out == "") {
	out = $0;
    } else {
	out = out "\t" $0;
    }
    if (NR % rlen == 0) {
	print out;
	out = "";
    }
}

END {
    if (out != "") {
	print out;
    }
}

