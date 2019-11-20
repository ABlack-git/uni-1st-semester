function get_department {
	department="{\"departmentName_s\": "$1", \"departmentOfficers\": ["$2"], \"departmentCars\": ["$3"]}"
}

function get_officer {
	officer="{\"isid_s\": "$1", \"firstName_s\": "$2", \"lastName_s\": "$3", \"rank_s\": "$4"}"
}

function get_car {
	car="{\"plate_s\": "$1", \"model\": "$2", \"assignedOfficers\": ["$3"]}"
}

get_department "\"North\"" "\"Larry Flint\",\"John Doe\"" "\"xyz777\""
echo "$department"
get_department "\"West\"" "\"Jane Doe\",\"Will Smith\", \"John McClane\"" "\"zxy007\", \"olx999\""
echo "$department"

get_officer "\"doejohn\"" "\"John\"" "\"Doe\"" "\"detective\""
echo "$officer"
get_officer "\"doejane\"" "\"Jane\"" "\"Doe\"" "\"sergeant\""
echo "$officer"