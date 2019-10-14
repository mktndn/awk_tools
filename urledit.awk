# Format Headline and URL in markdown.
#
BEGIN {
}

{a[FNR] = $0}

END {
    split(a[2], elements, /\//);
    split(elements[3], host, /\./);

    domain = "";
    for (i=2;i<=length(host);i++){
	domain = domain host[i] ".";
    }

    # check if domain exists. (sample. "stackoverflow.com" is host name and domain
    # name.
    i = 0;
    while (("nslookup " domain |& getline results ) > 0){
	lines[i++] = results;
    }
    if (match(lines[length(lines)-2], /^*/)) {
	domain = host[1] "." domain;
    } 

    domain = substr(domain, 1, length(domain)-1);

    out = "[" a[1] " (";
    out = out domain ")](" a[2] ")";
    print out;
}

