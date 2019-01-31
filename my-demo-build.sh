#!/bin/bash
CT="Content-Type:application/json"

URL='vtsip'

# Create keys in DSM and VTS
i=0
for i in {1..1}
do
keyname="vtskey"$i
Data='{"size" : 256 ,"name":"'$keyname'","kty" : "oct"}'
echo $keyname
echo $Data
args=(-k -X POST -H 'authorization: Basic dnRzcm9vdDpWb3JtZXRyaWMxMjMh' -H Content-Type:application/json -d ''"$Data"'' https://$URL/vts/km/v1/keys)
RESPONSE2= curl "${args[@]}"
echo $RESPONSE2
i=$i+1
done
#setup token 
PWD="yourvtspwd"
CT="Content-Type:application/json"
Credentials='{"username":"vtsroot","password":"'$PWD'"}'
echo $Credentials
AUTH="curl -k -X POST -H $CT -d $Credentials https://$URL/api/api-token-auth/"
RESPONSE=`$AUTH`
TOKEN=$(echo "$RESPONSE" | jq-linux64 -r '.token')
echo $TOKEN

# create tokengroups/tokentemplates

i=0
for i in {1..1}
do
groupname="vtsgroup"$i
keyname="vtskey"$i
templatename="vtstemplate"$i
Datagroup='{"name":"'$groupname'","key":"'$keyname'"}'
echo $keyname
echo $groupname
echo $templatename
echo $Datagroup
 
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$Datagroup"'' https://$URL/api/tokengroups/)
RESPONSE2= curl "${args[@]}"
echo $RESPONSE2
Datatemplate='{"name":"'$templatename'","tenant":"'$groupname'" ,"format": "FPE", "keepleft" : 0, "keepright": 0, "charset": "All digits", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $Datatemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$Datatemplate"'' https://$URL/api/tokentemplates/)
RESPONSETemplate= curl "${args[@]}"
echo $RESPONSETemplate

i=$i+1
done
Datagroup='{"name":"Demo","key":"vtskey1"}'
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$Datagroup"'' https://$URL/api/tokengroups/)
RESPONSE2= curl "${args[@]}"
echo $RESPONSE2

Datagroup='{"name":"t1","key":"vtskey1"}'
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$Datagroup"'' https://$URL/api/tokengroups/)
RESPONSE2= curl "${args[@]}"
echo $RESPONSE2

cctemplate='{"name":"Credit Card","tenant":"t1" ,"format": "FPE", "keepleft" : 0, "keepright": 0, "charset": "All digits", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $cctemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$cctemplate"'' https://$URL/api/tokentemplates/)
RESPONSEcc= curl "${args[@]}"
echo $RESPONSEcc

numerictemplate='{"name":"Numeric","tenant":"Demo" ,"format": "FPE", "keepleft" : 0, "keepright": 0, "charset": "All digits", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $numerictemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$numerictemplate"'' https://$URL/api/tokentemplates/)
RESPONSEnumeric= curl "${args[@]}"
echo $RESPONSEnumeric

texttemplate='{"name":"Text","tenant":"Demo" ,"format": "FPE", "keepleft" : 0, "keepright": 0, "charset": "Alphanumeric", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $texttemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$texttemplate"'' https://$URL/api/tokentemplates/)
RESPONSEtext= curl "${args[@]}"
echo $RESPONSEtext

prefixtemplate='{"name":"Text","tenant":"Demo" ,"format": "FPE", "keepleft" : 0, "keepright": 0, "charset": "Alphanumeric", "prefix": "pre-", "startyear": null, "endyear": null, "irreversible": false}'
echo $prefixtemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$prefixtemplate"'' https://$URL/api/tokentemplates/)
RESPONSEprefix= curl "${args[@]}"
echo $RESPONSEprefix

yyyymmddtemplate='{"name":"dateyyyymmdd","tenant":"Demo" ,"format": "YYYYMMDD", "keepleft" : 0, "keepright": 0, "charset": "All digits", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $yyyymmddtemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$yyyymmddtemplate"'' https://$URL/api/tokentemplates/)
RESPONSEyyyyddmm= curl "${args[@]}"
echo $RESPONSEyyyyddmm

dtshorttemplate='{"name":"dateyyyymmdd","tenant":"Demo" ,"format": "YYMMDD", "keepleft" : 0, "keepright": 0, "charset": "All digits", "prefix": "", "startyear": null, "endyear": null, "irreversible": false}'
echo $dtshorttemplate
args=(-k -X POST -H 'Authorization: JWT '"$TOKEN"'' -H Content-Type:application/json -d ''"$dtshorttemplate"'' https://$URL/api/tokentemplates/)
RESPONSEdtshort= curl "${args[@]}"
echo $RESPONSEdtshort




#create masks
curl -X POST "https://$URL/api/masks/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"name\": \"showleft6\", \"showleft\": 6, \"showright\": 0, \"maskchar\": \"?\"}"
curl -X POST "https://$URL/api/masks/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"name\": \"first2last2\", \"showleft\": 2, \"showright\": 2, \"maskchar\": \"X\"}"
curl -X POST "https://$URL/api/masks/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"name\": \"all\", \"showleft\": 99, \"showright\": 99, \"maskchar\": \"X\"}"
curl -X POST "https://$URL/api/masks/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"name\": \"last4\", \"showleft\": 0, \"showright\": 4, \"maskchar\": \"X\"}"


#create users
echo "password" $PWD
curl -X POST "https://$URL/api/users/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"username\": \"fraud\", \"email\":\"fraud@example.com\", \"password\": \"$PWD\", \"is_active\": true, \"is_staff\": true, \"is_superuser\": false}"
curl -X POST "https://$URL/api/users/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"username\": \"custserv1\", \"email\":\"custserv1@example.com\", \"password\": \"$PWD\", \"is_active\": true, \"is_staff\": true, \"is_superuser\": false}"
curl -X POST "https://$URL/api/users/" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"username\": \"custserv2\", \"email\":\"custserv2@example.com\", \"password\": \"$PWD\", \"is_active\": true, \"is_staff\": true, \"is_superuser\": false}"

#create permissions
#curl -X PATCH "https://$URL/api/users/usernbr1" -H "accept: application/json" -H "Content-Type: application/json" -H 'authorization: JWT '"$TOKEN"'' -k -d "{ \"user\": \"fraud\", \"key\": \"vtskey1\", \"canCreate\": true, \"canDestroy\": true, \"canModify\": true, \"canExport\": true, \"canFind\": true, \"canImport\": true}"