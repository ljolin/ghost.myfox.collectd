#!/bin/bash

sed -i -e "s/##HOSTNAME##/${HOSTNAME}/g" collectd.conf

