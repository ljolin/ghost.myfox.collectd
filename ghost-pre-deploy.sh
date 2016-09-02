#!/bin/bash

sed -i -e "s/##HOSTNAME##/${HOSTNAME}/g" collectd.conf
sed -i -e "s/##HOSTNAME##/${HOSTNAME}/g" collectd-confs-available/rabbitmq.conf
