#!/bin/bash
##########################################################################################################################################
# Script designed to resize all Kubernates clusters in a GCP project to 0 to prevent high expernses. |         Designed by Yonatan Brand
#########################################################################################################################################

export GCE_PROJECT=support-prod-157422

#############################################################

	for CLUSTER in `/snap/bin/gcloud container clusters list --filter="NUM_NODES=(1,2,3,4,5,6,7,8,9,10,11,12,13,14)" | awk '{ print $1 }' | sed -e "1d"`;do
		if grep -Fxq ${CLUSTER} /home/yonatanb/gcpOperator/logs/cluster_stay_on.txt;then
			echo -e "${CLUSTER} wont be powered off\n"
		else 
			ZONE=`/snap/bin/gcloud container clusters list | grep -E "^${CLUSTER} " | awk '{print $2}'`
			echo "$(date -u)  Resizing ${CLUSTER} ${ZONE}  in support-prod-157422"
			/snap/bin/gcloud container clusters resize ${CLUSTER} --project ${GCE_PROJECT} --zone ${ZONE} --size=0 --quiet >> /home/yonatanb/gcpOperator/logs/kubernetes.txt
		fi
done
	
#############################################################
