#!/bin/bash

set -x
set -e

AWS_BIN=$(which aws)
if [ $? -ne 0 ]; then
    AWS_BIN='/usr/local/bin/aws'
fi

if [ "$1" = 'tag-name' ]; then
  INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
  EC2_AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
  EC2_REGION="`echo \"$EC2_AVAIL_ZONE\" | sed -e 's:\([0-9][0-9]*\)[a-z]*\$:\\1:'`"
  TAGS=$($AWS_BIN ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region "$EC2_REGION")
  TAG_NAME=$(echo $TAGS | jq -r ".Tags[] | { key: .Key, value: .Value } | [.] | from_entries" | jq -r '.["Name"] | select (.!=null)')
  IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | tr -s '.' '-')
  MAX_NAME=$(($(getconf HOST_NAME_MAX)-16))
  MY_HOSTNAME=$(echo ${TAG_NAME:0:$MAX_NAME}-${IP}| tr -s '.' '-')
else
  MY_HOSTNAME=$HOSTNAME
fi

sed -i -e "s/##HOSTNAME##/${MY_HOSTNAME,,}/g" collectd.conf
sed -i -e "s/##HOSTNAME##/${MY_HOSTNAME,,}/g" collectd-confs-available/rabbitmq.conf

