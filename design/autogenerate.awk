BEGIN	{
	FS = ","; 
	print "/* This script is auto-generated - do not edit"
	print "   :License: 3-clause BSD. See LICENSE. */"
	printf "\nTHREAD_TABLE = ["
}

 /^[GPM]/	{
	gsub(/\r/, "");
	printf "[\"%s\", [%s, %s, %s, [", $1, $2, $3, $4;
        for (i = 5; i < NF + 1; i++) {
		if (i != 5) printf ", ";
		printf "[%s",$i ;
		i++;
                printf ", %s",$i "]"
		} 
        print "]]],";
}

END	{ print "];" }
