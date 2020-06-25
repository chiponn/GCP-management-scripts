#!/bin/bash
##############################################################################################################################
# Script designed to delete disks that are not uses by K8S Cluster.          |         Designed by Yonatan Brand
##############################################################################################################################

export GCE_PROJECT=support-prod-157422

#############################################################

        export COMMAND="grep gke diskList.txt"

        for CLUSTER in `/snap/bin/gcloud container clusters list | awk '{ print $1 }' | sed -e "1d"`;do
                export COMMAND="$COMMAND | grep -v ${CLUSTER}"
        done
        
        echo ${COMMAND}

        /snap/bin/gcloud compute disks list | awk '{ print $1 " " $2 }' | sed -e "1d" > /home/yonatanb/gcpOperator/logs/diskList.txt
        eval "$COMMAND > /home/yonatanb/gcpOperator/logs/toDel.txt"
        echo $RESULT

        while IFS=" " read -r name zone; do
		/snap/bin/gcloud compute disks delete $name --zone $zone --quiet
        done < /home/yonatanb/gcpOperator/logs/toDel.txt
#############################################################
