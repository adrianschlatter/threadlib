BEGIN	{
	FS = ","; 
	print "/* This script is auto-generated - do not edit"
	print "   :License: 3-clause BSD. See LICENSE. */"
	printf "\nTHREAD_TABLE = ["
}

 //	{
	gsub(/\r/, "");
	print "[\"" $1 "\", [" $2 ", " $3 ", " $4 ", [[" $5 ", " $6 "], [" \
	      $7 ", " $8 "], [" $9 ", " $10 "], [" $11 ", " $12 "]]]],";
}

END	{ print "];" }
