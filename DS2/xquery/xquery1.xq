(:construct departements with unpacked values:)
element departments {
	for $d in //departments/department
    return element departemnt {
    	element district {
        	text {$d/@district}
        },
        element officers {
        	for $o in $d/officers/officer
            return element offcier{
            	element name{
                text {//people/person[@id = $o/@personID]/name/text()}
                },
                element age{
                    text{//people/person[@id = $o/@personID]/age/text()}
                },
                element rank{
                	text{$o/@rank}
                }
            }
        }
    }
}
