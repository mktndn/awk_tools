#	groom.awk
#	貼り付けたテキスト文書をきれいにする
#	Linux Kernel参考書用
#		1. ハイフンを取る
#		2. 行頭の表示不能文字を箇条書きに変更する
#		3. 句読点(,.)の前にあるスペースを削除する
#		4. 連続する複数の空白を1つにする
#
BEGIN {
    buf = "";
    connector = ""
}

/[-]$/ {
    $0 = substr($0, 1, length($0)-1) connector;
}

/^[❑] */ {
    $0 = "\n  -" substr($0, 4);
}

{
    w = $0
    gsub(/ +,/, ",", w);
    gsub(/ +\./, ".", w);
    gsub(/ +;/, ";", w);
    gsub(/ \)/, ")", w);
    gsub(/\( /, "(", w);
    gsub(/[\t ]+/, " ", w);
    buf = buf w;
    last = substr(buf, length(buf), 1)

    if (last == "." || last == ":") {
	print buf;
	buf = "";
	print "\n";
    } else if (last == connector) {
	sub(connector, "", buf);
    } else if (last != " ") {
	buf = buf " ";
    }  
}

END {
    print buf;
}

