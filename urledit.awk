# Format Headline and host in markdown.
#
BEGIN {
}

{input[FNR] = $0}

END {
    split(input[2], url, /\//);
    split(url[3], host, /\./);

    domain = host[2];
    for (i=3; i<=length(host); ++i) {
	domain = domain "." host[i];
    }
    adrs = 0;
    while (("nslookup " domain |& getline aLine) == 1) {
	# print aLine;
	if (match(aLine, "Address") == 1) {
	    adrs++;
	    # print("this is address line.");
	}
    }
    # print adrs;
    if (adrs != 2) {
	domain = url[3];
    }

    split(input[2], urlWithoutQuery, "\\?")
    out = "[" input[1]" (";
    out = out domain ")](" urlWithoutQuery[1] ")";
    print out;
}
