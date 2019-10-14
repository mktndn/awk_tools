#
#	tabulate2.awk
#	tab区切りのテキスト表ファイルをcolumnがずれないように揃える
#	各セルは固定長で必要に応じて改行する
#
#	1行目が表見出し　この行の項目数を表の列数とする
#	各列の桁数は(1行の桁数/列数)とする
#	見出し行の下には区切り行を入れる
#	2行目以降は、各セルは列の桁数に収まるよう改行する
#	行数はセルによって異なる
#	行と行の間には空行を1行入れる
#
#	textwidth: 	1行の桁数 (79)
# 	colTop[n]:     各columnの開始桁数
#	colTop[n]:     	各columnの開始桁数
#	nCols:		表のcolumn数 (1~)
#	lines[n]:	入力各行(1~)
#	colWd:		1つの列の桁数（浮動小数点値）
#

# 小数部の切り下げ
#   in:     数値 num
#   out:    数値 num の小数部を切り下げたもの
function floor(num) {
    if (int(num) == num) {
        return num;
    } else if (num > 0){
        return int(num);
    } else {
        return int(num) - 1;
    }
}



BEGIN {
    textwidth = 79;
    True = 1;
    False = 0;
    FS = "\t";
}

/.*/ {
    # pass 1. 入力行をバッファに読み込む

    # 最初の行は見出し
    if (NR == 1){
	    nCols = NF;
    }
    lines[NR] = $0;
}

END {
    colWd = textwidth / nCols	# 浮動小数点値
    for(i = 1; i <= nCols; ++i){
	colTop[i] = int(colWd * (i - 1))
    }
    colTop[nCols + 1] = -1

    #
    # 結果出力
    # 入力1行に対して出力行数不定
    # 入力1行ずつ処理する　1行読んだら複数行出力　これを入力行が終わるまで繰り返す

    for (i = 1; i <= NR; ++i) {
	split(lines[i], org, FS);
	maxLine[i] = 0;

	# まず各セルを規定の長さに分割して配列に格納する
	# org: 元の入力行
	# cellLines[nCols, n]: 出力行
	# cellLines[nCols, n+1]: そのセルの内容がnで終わりの時は (ctrl-G)が入る
	# maxLine[n]:	その行で一番長いセルの出力行数（1~)
	# colWd:
	# 1つの列の桁数（浮動小数点値）最後の文字は空白にする必要がある
	for (j = 1; j <= nCols; ++j){
	    # 入力行の連続する複数の空白文字を1つにする
	    sub(org[j], /\s+/, " ");
	    lineCur = 1;

	    while (length(org[j]) > int(colWd - 1)) {
		for(k = int(colWd - 1); k >= 1; --k){                   # 区切り位置から先頭に戻って検索
		    if (substr(org[j], k, 1) == " "){			# 空白あり　ここで切ってよい
			cellLines[j, lineCur++] = substr(org[j], 1, k);	# 切り出して出力を1行作成
			org[j] = substr(org[j], k + 1);                	# その分残りを短くする
			break;
		    }
		}

		if (k == 0) {	# 空白が見つからなかった
		    cellLines[j, lineCur] = substr(org[j], 1, floor(colWd - 1) - 2);	# 区切り位置-1で強制的に切る
		    cellLines[j, lineCur] = cellLines[j, lineCur] "-";			# 無理にハイフンを入れる
		    lineCur++;
		    org[j] = substr(org[j], floor(colWd - 1) - 1);  	            	# その分残りを短くする
		}
	    }
	    cellLines[j, lineCur] = org[j];
	    cellLines[j, lineCur + 1] = "";		# 終了マーク

	    if (maxLine[i] < lineCur) {
		maxLine[i] = lineCur;
	    }
	}
	# 処理結果出力
	# cellLines[nCols, n]: 出力行
	# cellLines[nCols, n+1]: そのセルの内容がn行で終わりの時は (ctrl-G)が入る
	# maxLine[n]: 	その行で一番長いセルの出力行数（1~)
	# out:		1行分の出力を組み立てるためのバッファ
	# curx:		出力行内のカーソル(1 .. textwidth)
	# fColEnd[nCols]:そのセルの出力が終了したかどうかのフラグ

	for (j = 1; j <= nCols; ++j) {	# 終了フラグをクリア
	    fColEnd[j] = False;
	}

	for (k = 1; k <= maxLine[i]; ++k) {
	    out = "";
	    curx = 1;
	    for (j = 1; j <= nCols; ++j) {
		if (fColEnd[j] == False) {
		    if (cellLines[j, k] == ""){	# セルの終了をチェックして
			fColEnd[j] = True;		# フラグを立てる
		    }
		}
		if (fColEnd[j] == False) {		# 終了してなかったら
		    out = out cellLines[j, k];		# 内容をバッファに出力して
		    curx += length(cellLines[j, k]);	# カーソルを動かす
		}

		for (; curx < colTop[j + 1]; curx++){	# 残りを空白で埋める
		    out = out " ";
		}
	    }
	    print (out);		# 1行出力
	}

	if (i == 1) {			# もし見出し行の後なら
	    out = "";			# 区切り行出力
	    cur = 1;
	    for(k = 1; k <= nCols; ++k) {
		for (j = 1; j < int(colWd - 1); ++j) {
		    out = out "-";
		    cur++;
		}
		for (; cur < colTop[k + 1]; ++cur) {
		    out = out " ";
		}
	    }
	    print (out)
	} else {
	    print ("");			# 2行目以後なら空行出力
	}
    }

}


