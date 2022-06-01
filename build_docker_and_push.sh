#!/usr/bin/env bash
sudo docker build -t scylladbdump:v2 .
sudo docker tag scylladbdump:v2 klinkbr/wisecapture:dump_v2
sudo docker push klinkbr/wisecapture:dump_v2
