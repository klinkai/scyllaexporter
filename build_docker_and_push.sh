#!/usr/bin/env bash
sudo docker build -t scylladbdump:latest .
sudo docker tag scylladbdump:latest klinkbr/wisecapture:latest
sudo docker push klinkbr/wisecapture:latest