#!/bin/bash

echo " Executing containers removal ..."

docker ps -a | awk '{print $1}' |grep -v "CONTAINER" >/tmp/toRemove.txt
for each in $(cat /tmp/toRemove.txt); do
	docker stop $each
	docker rm -f $each
done

echo " Executing volume removal ..."
docker volume ls | awk '{print $2}'| grep -v "VOLUME" >/tmp/volumesToBeRemoved.txt
for volume in $(cat /tmp/volumesToBeRemoved.txt); do
	docker volume rm $volume
done

echo "Process completed with status code 0"
