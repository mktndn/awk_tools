#!/usr/bin/gawk
#
#	Usage: gawk -f numlist.awk {var=value, {var=value...}}
#	var: 
#		offset: numbering offset relative to NR.
#			Default: 0
#
#		type: numbering type.
#			n: Number (1, 2, 3, ...)
#			r: Roman (I, II, III, IV, ...)
#			a: Alphabet (a, b, c, ...)
#			Default: n
#
#		postfix: postfix of numbering characters.
#			specify literal character.
#			Default: . (period)
#
# Library Functions. 
# from GNU Awk User's Guide.
#
     # ord.awk --- do ord and chr
     
     # Global identifiers:
     #    _ord_:        numerical values indexed by characters
     #    _ord_init:    function to initialize _ord_
#     BEGIN    { _ord_init() }/*{{{*/
function _ord_init(low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7
    if (low == "\a") {    # regular ascii
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
        low = 128
        high = 255
    } else {        # ebcdic(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}

function ord(str)
{
    # only first character is of interest
    c = substr(str, 1, 1)
    return _ord_[c]
}

function chr(c)
{
    # force c to be numeric by adding 0
    return sprintf("%c", c + 0)
}
/*}}}*/
#
#
BEGIN {
    _ord_init();
    if (offset == "" || offset < 0) offset = 0;
    if (type == "") type = "n";
    if (postfix == "") postfix = ".";

    split("i, ii, iii, iv, v, vi, vii, viii, ix, x, xi, xii, xiii, xiv, xv, xvi, xvii, xviii, xix, xx", roman, ", ")
    
    for (i=1; i<=20; ++i) {
	num["n", i] = sprintf("%d", i);
	num["r", i] = sprintf("%5s", roman[i]);
	num["a", i] = chr(ord("a") + (i - 1));
    }
}

/.*/ {print num[type, NR + offset] postfix " " $0}

END {
}

