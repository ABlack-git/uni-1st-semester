(:print conditionally whether person is a victim in any investigation:)
for $p in //people/person
	return <isVictim name="{$p/name/text()}">{
    if (count(//involvedPeople/person[@id = $p/@id and @role="victim"])>0)
    then "I am victim"
    else "I am not victim"
    }</isVictim>