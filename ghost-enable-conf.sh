#!/bin/bash

set -e
set -x

cd ./collectd.d/ 
for conf in $@; do
    ln -ns ../collectd-confs-available/${conf}.conf
done

