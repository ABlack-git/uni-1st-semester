#!/usr/bin/env bash

# This database describes police departments, officers and police cars.
# Departments have links to officers and cars, listing which officers work and which cars belong to the given PD
# Officers have links to police departments and cars. Links to car represent that this officer can drive this car.
# Cars have links to PDs and officers.

BASE_URL=http://localhost:10011
LOGIN=${1:-f191_zakhaand}
DEP_BUCKET=/buckets/${LOGIN}_departments
OFFICERS_BUCKET=/buckets/${LOGIN}_officers
CARS_BUCKET=/buckets/${LOGIN}_cars
DEP_URL=${BASE_URL}${DEP_BUCKET}
OFFICERS_URL=${BASE_URL}${OFFICERS_BUCKET}
CARS_URL=${BASE_URL}${CARS_BUCKET}

DEP_KEYS=()
OFFICERS_KEYS=()
CARS_KEYS=()

function put {
	# uncomment lines below to see how curl command loooks like during script execution
	local data="$1"
	local url="$2"
	shift 2
	local headers=("$@")
	# set -x
	curl -i -X PUT -H 'Content-Type: application/json' "${headers[@]}" -d "${data}" "${url}"
	# set +x
	echo ""
}

function get {
	local url="$1"
	curl -i -X GET "${url}"
	echo ""
}

function delete {
	# uncomment lines below to see how curl command loooks like during script execution
	local url="$1"
	# set -x
	curl -X DELETE "${url}"
	# set +x
	echo "Deleted ${url}"
}

function delete_bucket {
	local bucket_url="$1"
	shift
	local keys=("$@")
	
	for key in "${keys[@]}"; do
		delete "${bucket_url}/keys/${key}"
	done
}

# find use of this function in script and uncomment it to see all entries returned
function multi_get {
	local bucket_url="$1"
	shift
	local keys=("$@")
	for key in "${keys[@]}"; do
		get "${bucket_url}/keys/${key}"
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
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/flintl>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/doejohn>; riaktag=\"tofficers\""
	'-H' "Link: <${CARS_BUCKET}/keys/xyz777>; riaktag=\"tcars\"")
DEP_KEYS+=("north")
put "${department}" "${DEP_URL}/keys/north" "${headers[@]}"

get_department "\"West\"" "\"doejane\",\"smithw\", \"mcclane\"" "\"zxy007\", \"olx999\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/doejane>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/smithw>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/mcclane>; riaktag=\"tofficers\""
	'-H' "Link: <${CARS_BUCKET}/keys/zxy007>; riaktag=\"tcars\""
	'-H' "Link: <${CARS_BUCKET}/keys/olx999>; riaktag=\"tcars\"")
DEP_KEYS+=("west")
put "${department}" "${DEP_URL}/keys/west" "${headers[@]}"

get_department "\"East\"" "\"robocop\", \"murtagh\"" "\"ons345\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/robocop>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/murtagh>; riaktag=\"tofficers\""
	'-H' "Link: <${CARS_BUCKET}/keys/ons345>; riaktag=\"tcars\"")
DEP_KEYS+=("east")
put "${department}" "${DEP_URL}/keys/east" "${headers[@]}"

get_department "\"South\"" "\"somerset\"" "\"xyz909\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/somerset>; riaktag=\"tofficers\""
	'-H' "Link: <${CARS_BUCKET}/keys/xyz909>; riaktag=\"tcars\"")
DEP_KEYS+=("south")
put "${department}" "${DEP_URL}/keys/south" "${headers[@]}"

get_department "\"Downtown\"" "\"khan\", \"harrison\"" "\"zxy123\", \"olx545\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/khan>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/harrison>; riaktag=\"tofficers\""
	'-H' "Link: <${CARS_BUCKET}/keys/zxy123>; riaktag=\"tcars\""
	'-H' "Link: <${CARS_BUCKET}/keys/olx545>; riaktag=\"tcars\"")
DEP_KEYS+=("downtown")
put "${department}" "${DEP_URL}/keys/downtown" "${headers[@]}"

######PUT OFFICERS######

get_officer "\"flintl\"" "\"Larry\"" "\"Flint\"" "\"officer\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/north>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/xyz777>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("flintl")
put "${officer}" "${OFFICERS_URL}/keys/flintl" "${headers[@]}"

get_officer "\"doejohn\"" "\"John\"" "\"Doe\"" "\"detective\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/north>; riaktag=\"tdep\"")
OFFICERS_KEYS+=("doejohn")
put "${officer}" "${OFFICERS_URL}/keys/doejohn" "${headers[@]}"

get_officer "\"doejane\"" "\"Jane\"" "\"Doe\"" "\"sergeant\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/west>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/olx999>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("doejane")
put "${officer}" "${OFFICERS_URL}/keys/doejane" "${headers[@]}"

get_officer "\"smithw\"" "\"Will\"" "\"Smith\"" "\"officer\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/west>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/zxy007>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("smithw")
put "${officer}" "${OFFICERS_URL}/keys/smithw" "${headers[@]}"

get_officer "\"mcclane\"" "\"John\"" "\"McClane\"" "\"detective\""
headers=('-H' "Link: <${CARS_BUCKET}/keys/zxy007>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("mcclane")
put "${officer}" "${OFFICERS_URL}/keys/mcclane" "${headers[@]}"

get_officer "\"robocop\"" "\"Rob\"" "\"O'Cop\"" "\"officer\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/east>; riaktag=\"tdep\"")
OFFICERS_KEYS+=("robocop")
put "${officer}" "${OFFICERS_URL}/keys/robocop" "${headers[@]}"

get_officer "\"murtagh\"" "\"Roger\"" "\"Murtagh\"" "\"detective\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/east>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/ons345>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("murtagh")
put "${officer}" "${OFFICERS_URL}/keys/murtagh" "${headers[@]}"

get_officer "\"somerset\"" "\"William\"" "\"Somerset\"" "\"sergeant\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/south>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/xyz909>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("somerset")
put "${officer}" "${OFFICERS_URL}/keys/somerset" "${headers[@]}"

get_officer "\"khan\"" "\"Salmon\"" "\"Khan\"" "\"sergeant\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/downtown>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/zxy123>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("khan")
put "${officer}" "${OFFICERS_URL}/keys/khan" "${headers[@]}"

get_officer "\"harrison\"" "\"Nill\"" "\"Harrison\"" "\"officer\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/downtown>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/olx545>; riaktag=\"tcars\"")
OFFICERS_KEYS+=("harrison")
put "${officer}" "${OFFICERS_URL}/keys/harrison" "${headers[@]}"

######PUT CARS######

get_car "\"xyz777\"" "\"Ford\"" "\"flintl\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/flintl>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/north>; riaktag=\"tdep\"")
CARS_KEYS+=("xyz777")
put "${car}" "${CARS_URL}/keys/xyz777" "${headers[@]}"

get_car "\"olx999\"" "\"Skoda\"" "\"doejane\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/doejane>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/west>; riaktag=\"tdep\"")
CARS_KEYS+=("olx999")
put "${car}" "${CARS_URL}/keys/olx999" "${headers[@]}"

get_car "\"zxy007\"" "\"Skoda\"" "\"mcclane\", \"smithw\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/mcclane>; riaktag=\"tofficers\""
	'-H' "Link: <${OFFICERS_BUCKET}/keys/smithw>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/west>; riaktag=\"tdep\"")
CARS_KEYS+=("zxy007")
put "${car}" "${CARS_URL}/keys/zxy007" "${headers[@]}"

get_car "\"ons345\"" "\"GMC\"" "\"murtagh\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/murtagh>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/east>; riaktag=\"tdep\"")
CARS_KEYS+=("ons345")
put "${car}" "${CARS_URL}/keys/ons345" "${headers[@]}"

get_car "\"xyz909\"" "\"Toyota\"" "\"somerset\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/somerset>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/south>; riaktag=\"tdep\"")
CARS_KEYS+=("xyz909")
put "${car}" "${CARS_URL}/keys/xyz909" "${headers[@]}"

get_car "\"zxy123\"" "\"VW\"" "\"khan\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/khan>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/downtown>; riaktag=\"tdep\"")
CARS_KEYS+=("zxy123")
put "${car}" "${CARS_URL}/keys/zxy123" "${headers[@]}"

get_car "\"olx545\"" "\"Ford\"" "\"harrison\""
headers=('-H' "Link: <${OFFICERS_BUCKET}/keys/harrison>; riaktag=\"tofficers\""
	'-H' "Link: <${DEP_BUCKET}/keys/downtown>; riaktag=\"tdep\"")
CARS_KEYS+=("olx545")
put "${car}" "${CARS_URL}/keys/olx545" "${headers[@]}"

######UPDATE GET AND LINK WALKING######
get "${OFFICERS_URL}/keys?keys=true"
get "${DEP_URL}/keys?keys=true"
get "${CARS_URL}/keys?keys=true"

# multi_get "${DEP_URL}" "${DEP_KEYS[@]}"
# multi_get "${OFFICERS_URL}" "${OFFICERS_KEYS[@]}"
# multi_get "${CARS_URL}" "${CARS_KEYS[@]}"

echo "Check that mcclane doesn't have link to department"
get "${OFFICERS_URL}/keys/mcclane"
echo "Update mcclane to have link to department"
get_officer "\"mcclane\"" "\"John\"" "\"McClane\"" "\"detective\""
headers=('-H' "Link: <${DEP_BUCKET}/keys/west>; riaktag=\"tdep\""
	'-H' "Link: <${CARS_BUCKET}/keys/zxy007>; riaktag=\"tcars\"")
put "${officer}" "${OFFICERS_URL}/keys/mcclane" "${headers[@]}"
sleep 2
echo "Check mcclane update"
get "${OFFICERS_URL}/keys/mcclane"
echo "Show all officers in west department"
get "http://localhost:10011/buckets/f191_zakhaand_departments/keys/west/f191_zakhaand_officers,tofficers,1"
echo "Show all cars that are in the same departments as officer mcclane"
get "http://localhost:10011/buckets/f191_zakhaand_officers/keys/mcclane/f191_zakhaand_departments,tdep,0/f191_zakhaand_cars,tcars,1"
######DELETE BUCKETS######
echo "Deleting department bucket"
delete_bucket "${DEP_URL}" "${DEP_KEYS[@]}"
echo "Deleting officers bucket"
delete_bucket "${OFFICERS_URL}" "${OFFICERS_KEYS[@]}"
echo "Deleting cars bucket"
delete_bucket "${CARS_URL}" "${CARS_KEYS[@]}"
