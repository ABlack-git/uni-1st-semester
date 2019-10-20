(:output investigation name and a district where at least one involved person is underaged:)
for $i in //investigation
    where some $p in $i/involvedPeople/person satisfies (//people/person[@id eq $p/@id]/age < 18)
return <investigation>
			<name>{$i/investigationDescription/text()}</name>
            <district>{string(//departments/department[@id eq $i/@departmentId]/@district)}</district>
</investigation>
