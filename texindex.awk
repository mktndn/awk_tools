# texindex.awk
# latex文書のインデックス (concordance)を作成する
# キーワードを指定するとすべての出現位置に \index{キーワード}を追加する
# すべてと言ってもドキュメントの内容に限る
#
BEGIN {
    go = "no"
}

/begin{document}/ { go = "yes" }
/end{document}/ { go = "no" }

{
    repl = key " \\\\index{" key "} "
    if (!match($0, key))
	print $0
    else if (match($0, "[\\\\\\[\\]\\{\\}]")) {
	print $0
	print "\\index{" key "}"
    } else {
	print gensub(key, repl, $0)
    }
}

END {
    print (key " : " repl)
}

