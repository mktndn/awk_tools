#	toc.awkで作った目次を元に戻す: untoc.awk
#
BEGIN {
	true = 0;
	false = -1;
}

$0 ~ /^([0-9]\.)+([0-9])* / {
	lvl = 0;
	i = 0;
	char = "";
	indigit = false;

	while ((char = substr($0, i, 1))!=" ") {
		if (match(char, "[0-9]")) {
			if (indigit == false) {
				indigit = true;
				lvl++;
			}
		} else if (char == ".") {
			indigit = false;
		}
		++i;
	}

	if (match(char, "[0-9]")) {
		lvl++;
	}

	out = "";
	for (j = 0; j < lvl; ++j) {
		out = out "N";
	}

	out = out "|" substr($0, i);
	print out;
}

# 何でもない行には何にもしない
$0 !~ /^[0-9]/ {
	print $0;
}

END {
}
