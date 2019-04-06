BEGIN	{ print "/* This script is auto-generated - do not edit */"
	  printf "\nTHREAD_TABLE = [" }
/^G/	{ print "[\"" $1 "\", [" $2 ", " $3 ", " $4 ", [[" $5 ", " $6 "], [" $7 ", " $8 "], [" $9 ", " $10 "], [" $11 ", " $12 "]]]],"}
END	{ print "];" }
