BASE_URL=http://localhost:10011
LOGIN=${$1:-f191_zakhaand}
BUCKETS=${BASE_URL}/buckets
DEP_URL=${BUCKETS}/${LOGIN}_departments
OFFICERS_URL=${BUCKETS}/${LOGIN}_officers
CARS_URL=${BUCKETS}/${LOGIN}_cars

DEP_KEYS=()
OFFICERS_KEYS=()
CARS_KEYS=()

function put {
local headers="$1"
local data="$2"
local url="$3"
curl -i -X PUT "${headers[@]}" -d "${data}" "${url}"
}

function get {
local url="$1"
curl -i -X GET "${url}"
}

function delete {
local url="$1"
curl -i -X DELETE "${url}"
}

function delete_bucket {
	local bucket_url="$1"
	local keys="$2"
	
	for key in ${keys[@]}; do
		delete "${bucket_url}/keys/${key}"
	done
}

function get_department {
	department="{\"departmentName_s\": "$1", \"departmentOfficers\": ["$2"], \"departmentCars\": ["$3"]}"
}

function get_officer {
	officer="{\"isid_s\": "$1", \"firstName_s\": "$2", \"lastName_s\": "$3", \"rank_s\": "$4"}"
}

function get_car {
	car="{\"plate_s\": "$1", \"model\": "$2", \"assignedOfficers\": ["$3"]}"
}

######PUT DEPARTMENTS######

get_department "\"North\"" "\"flintl\",\"doejohn\"" "\"xyz777\""
headers=()
DEP_KEYS+=("north")
put $headers "${department}" "${DEP_URL}/keys/north"
get "${DEP_URL}/keys/north"

get_department "\"West\"" "\"doejane\",\"smithw\", \"mcclane\"" "\"zxy007\", \"olx999\""
headers=()
DEP_KEYS+=("west")
put $headers "${department}" "${DEP_URL}/keys/west"
get "${DEP_URL}/keys/west"

get_department "\"East\"" "\"\"" "\"xyz777\""
headers=()
DEP_KEYS+=("east")
put $headers "${department}" "${DEP_URL}/keys/east"
get "${DEP_URL}/keys/east"

######PUT OFFICERS######

get_officer "\"flintl\"" "\"Larry\"" "\"Flint\"" "\"officer\""
headers=()
OFFICERS_KEYS+=("flintl")
put $headers "${officer}" "${OFFICERS_URL}/keys/flintl"
get "${OFFICERS_URL}/keys/flintl"

get_officer "\"doejohn\"" "\"John\"" "\"Doe\"" "\"detective\""
headers=()
OFFICERS_KEYS+=("doejohn")
put $headers "${officer}" "${OFFICERS_URL}/keys/doejohn"
get "${OFFICERS_URL}/keys/doejohn"

get_officer "\"doejane\"" "\"Jane\"" "\"Doe\"" "\"sergeant\""
headers=()
OFFICERS_KEYS+=("doejane")
put $headers "${officer}" "${OFFICERS_URL}/keys/doejane"
get "${OFFICERS_URL}/keys/doejane"

get_officer "\"smithw\"" "\"Will\"" "\"Smith\"" "\"officer\""
headers=()
OFFICERS_KEYS+=("smithw")
put $headers "${officer}" "${OFFICERS_URL}/keys/smithw"
get "${OFFICERS_URL}/keys/smithw"

get_officer "\"mcclane\"" "\"John\"" "\"McClane\"" "\"detective\""
headers=()
OFFICERS_KEYS+=("mcclane")
put $headers "${officer}" "${OFFICERS_URL}/keys/mcclane"
get "${OFFICERS_URL}/keys/mcclane"

######PUT CARS######

get_car "\"\"" "\"\"" "\"\",\"\""
headers=()
CARS_KEYS+=()
put $headers "${car}" "${CARS_URL}/keys/"
get "${CARS_URL}/keys/"


######DELETE BUCKETS######
delete_bucket "${DEP_URL}" $DEP_KEYS
delete_bucket "${OFFICERS_URL}" $OFFICERS_KEYS
delete_bucket "${CARS_URL}" $CARS_KEYS