#
#	目次作成: toc.awk
#
#	入力フォーマット：
#		N|	レベル1
#		NN|	レベル2
#		以下同様
#
#	出力フォーマット：
#		1.	レベル1
#		1.1	レベル2
#		以下同様
#
#	レベルは一応5までを想定
#
BEGIN {
	lvlMax = 5;
	for (i=1; i<=lvlMax; ++i) {
		cnt[i] = 0;
	}
}

/^N+\|/ {
	match($0, /^N+\|/);
	lvl = RLENGTH - 1;

	out = ""
	cnt[lvl]++;
	if (lvl == 1){
		out = out cnt[lvl] ".";
	} else {
		for (i=1; i<lvl; ++i){
			out = out cnt[i] ".";
		}
		out = out cnt[lvl]
	}
	for (i = lvl + 1; i <= lvlMax; ++i) {
		cnt[i] = 0;
	}
	out = out substr($0, RLENGTH + 1) 
	print (out)
}

$0 !~ /^N+\|/ {
	print $0;
}
  
END {
}


