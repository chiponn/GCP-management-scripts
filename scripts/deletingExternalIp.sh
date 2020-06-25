#!/usr/bin/env bash
###################################################################################################################
# Script designed to delete external ip addresses that are not in use.          |         Designed by Yonatan Brand
###################################################################################################################

export GCE_PROJECT=support-prod-157422

#############################################################

for EXTERNAL in `/snap/bin/gcloud compute addresses list --filter="-PURPOSE:*" | grep RESERVED | awk '{ print $1 }'`;do
    if grep -Fxq ${EXTERNAL} /home/yonatanb/gcpOperator/logs/whitelistIpAddresses.txt;then
        echo -e "The External IP Address - ${EXTERNAL} wont be deleted\n"
    else
        REGION=`/snap/bin/gcloud compute addresses list --filter="-PURPOSE:*" | grep RESERVED | grep -E "^${EXTERNAL}" | awk '{ print $4 }' | head -n 1`
        echo "Deleting external IP address with the name $EXTERNAL from $REGION"
        `/snap/bin/gcloud compute addresses delete $EXTERNAL --region $REGION --quiet`
        sleep 5
    fi
done
#############################################################
