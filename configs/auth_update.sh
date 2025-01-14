#!/bin/sh

nx_conf=/etc/nginx/nginx.conf

# update the auth token
if [ "$REGISTRY_ID" = "" ]
then
    aws_cli_exec=$(aws ecr get-login --region $AWS_REGION --no-include-email)
else
    aws_cli_exec=$(aws ecr get-login --region $AWS_REGION --no-include-email --registry-ids $REGISTRY_ID)
fi
token=$(echo $aws_cli_exec | awk '{print $6}')
auth_n=$(echo AWS:${token}  | base64 |tr -d "[:space:]")

auth_1=$(grep 'set $token1' "${nx_conf}" | awk '{print $3}'| uniq|tr -d "\n\r")
auth_2=$(grep 'set $token2' "${nx_conf}" | awk '{print $3}'| uniq|tr -d "\n\r")

auth_split_1=$(echo $auth_n | awk '{print substr($0,1,2000)}')
auth_split_2=$(echo $auth_n | awk '{print substr($0,2001)}')

sed -i "s|${auth_1%?}|${auth_split_1}|g" "${nx_conf}"
sed -i "s|${auth_2%?}|${auth_split_2}|g" "${nx_conf}"

reg_url=$(echo "${aws_cli_exec}" | awk '{print $7}')
sed -i "s|REGISTRY_URL|$reg_url|g" "${nx_conf}"