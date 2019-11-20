set -x
BASE_URL=http://localhost:10011
LOGIN=${1:-f191_zakhaand}
DEP_BUCKET=/bucket/${LOGIN}_departments
OFFICERS_BUCKET=/bucket/${LOGIN}_officers
CARS_BUCKET=/bucket/${LOGIN}_cars
DEP_URL=${BASE_URL}${DEP_BUCKET}
OFFICERS_URL=${BASE_URL}${OFFICERS_BUCKET}
CARS_URL=${BASE_URL}${CARS_BUCKET}

DEP_KEYS=()
OFFICERS_KEYS=()
CARS_KEYS=()

function put {
	local data="$1"
	local url="$2"
	shift 2
	local headers=("$@")
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
	shift
	local keys=("$@")
	
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

get_department "\"North\"" "\"flintl\",\"doejohn\"" "\"xyz777\""
headers=('-H' "Link: </buckets/keys/flintl>; riaktag=\"tofficers\""
	'-H' "Link: </buckets/keys/doejohn>; riaktag=\"tofficers\""
	'-H' "Link: </buckets/keys/xyz777>; riaktag=\"tcars\"")
DEP_KEYS+=("north")
put "${department}" "${DEP_URL}/keys/north" "${headers[@]}"
get "${DEP_URL}/keys/north"