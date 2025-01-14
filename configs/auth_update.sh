#!/bin/sh

nx_conf=/etc/nginx/nginx.conf

# update the auth token
if [ "$REGISTRY_ID" = "" ]
then
    token=$(aws ecr get-login --no-include-email | awk '{print $6}')
else
    token=$(aws ecr get-login --no-include-email --registry-ids $REGISTRY_ID | awk '{print $6}')
fi
auth_n=$(echo AWS:${token}  | base64 |tr -d "[:space:]")

auth_1=$(grep 'set $token1' "${nx_conf}" | awk '{print $3}'| uniq|tr -d "\n\r")
auth_2=$(grep 'set $token2' "${nx_conf}" | awk '{print $3}'| uniq|tr -d "\n\r")

auth_split_1=$(echo $auth_n | awk '{print substr($0,1,length/2)}')
auth_split_2=$(echo $auth_n | awk '{print substr($0,length/2+1)}')

sed -i "s|${auth_1%?}|${auth_split_1}|g" "${nx_conf}"
sed -i "s|${auth_2%?}|${auth_split_2}|g" "${nx_conf}"
sed -i "s|REGISTRY_URL|$reg_url|g" "${nx_conf}"