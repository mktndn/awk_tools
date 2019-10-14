#
#	tabulate.awk
#	tab区切りのテキスト表ファイルをcolumnがずれないように揃える
#	各列の桁数は可変長で、表の中の最も長い行の値が使われる
#
#	shiftWidth: 	タブ桁数
#	nCols:		表のcolumn数 (1~)
#	colTop[n]:     	各columnの開始桁数
#	Max[n]:		n個めのcolumnの最大長 (1~)
#	lines[n]:	入力各行(1~)
#
BEGIN {
	FS = "\t";
	shiftWidth = 8;
	Max[0] = 0;
}

/.*/ {
	# 1 pass. 各columnの最長長さを得る
	# 併せてバッファに行を読み込む

	# 最初の行が見出し
	if (NR == 1){
		for (i=1; i<=NF; ++i){
			Max[i] = 0;
			nCols = NF;
		}
	}

        for (i=1; i <= NF; ++i) {
		if (length($i) > Max[i]){
			Max[i] = length($i);
		}
	}
	lines[NR] = $0;
}

END {
	#
	# 各columnの開始桁数を決める
	# 前のcolumnとの差分は：
	# (int(max(i)/shiftWidth) * shiftWidth) + ((max(i) % shiftWidth) >0)? shiftWidth: 0
	# 0123456789
	#         ^ pos % shiftWidth == 0のときはtabが1つ必要
	colTop[0] = 0;
	for (i=1; i<=nCols; ++i) {
		colTop[i] = colTop[i - 1] + int(Max[i] / shiftWidth) * shiftWidth; 
		if ((Max[i] % shiftWidth) > 0) {
			colTop[i] += shiftWidth;
		}
	}
	colTop[i + 1] = -1;

	# 1行出力
	for (i=1; i <= NR; ++i) {
		out = ""
		split(lines[i], org, FS)
		for (j=1; j<=nCols; ++j){
			out = out org[j];
			tabs = int(Max[j] / shiftWidth) - int(length(org[j]) / shiftWidth)
			for (k=0; k <= tabs; ++k) {
				out = out "\t"
			}
		}
		print (out)

		if (i == 1) {			# もし見出し行の後なら
		    out = "";			# 区切り行出力
		    cur = 1;
		    for(j = 1; j <= nCols; ++j) {
			for(k = 1; k <= Max[j]; k++) {
			    out = out "-";
			    cur++;
			}
			for(; cur <= colTop[j]; ++cur) {
			    out = out " ";
			}
		    }
		    print (out)
		} 
	}

}

