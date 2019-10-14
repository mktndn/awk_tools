#	gr2.awk
#	貼り付けたテキスト文書をきれいにする
#	IBM Redbook TCP/IP tutorial用
#
#		1. 単語内のハイフンを取る
#		2. 行頭の表示不能文字を箇条書きに変更する
#
BEGIN {
    buf = "";
    connector = "qqwq"
    breaker = "qqzq"
}

/[-]$/ {	# 行末のハイフン
    $0 = substr($0, 1, length($0)-1) connector;
}

/^[❑] */ {	# 表示不能の箇条書き
    $0 = breaker "  - " substr($0, 4);
}

{
    # these lines modifies $0. (the default third parameter is $0)
    gsub(/ +,/, ",");
    gsub(/ +\./, ".");
    gsub(/ +;/, ";");
    gsub(/ \)/, ")");
    gsub(/\( /, "(");
    gsub(/[\t ]+/, " ");

    split($0, words, " ");	# 1行を単語単位に分割する
    w = ""
    for(i = 1; i < length(words); ++i) {	# 単語内のハイフンを取る
	gsub(/­/, "", words[i]);
	w = w words[i] " ";			# 後ろに単語がある場合はスペースを挟む
    }
    gsub(/­/, "", words[i]);
    w = w words[i];                             # 最後の単語の後ろにはスペースなし

    # 入力行1行処理終了
    buf = buf w;
    lb = 0;					# line break?

    if (match(buf, /(\.\”|\.|\:)$/)) {		# 行末が"."または":"
	lb = 1;
	buf = buf "\n";
    }
    if (match(buf, "^" breaker)) {		# 行頭が改行マーク
	lb = 1
	gsub(breaker, "", buf)
	buf = "\n" buf;
    }

    if (lb == 1) {
	print buf;
	buf = "";
    } else if (match(buf, connector "$")) {	# 行末がハイフンマーク
	gsub(connector, "", buf);
    } 
    else {
	buf = buf " ";
    }  
}

END {
    print buf;
}

