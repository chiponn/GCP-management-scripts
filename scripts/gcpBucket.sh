#!/usr/bin/env bash
##############################################################################################################################
# Script designed to delete all instances that were not used in the last 20 days.          |         Designed by Yonatan Brand
##############################################################################################################################

export GCE_PROJECT=

#############################################################

/snap/bin/gsutil ls > /home/yonatanb/gcpOperator/logs/bucketList.txt
input="/home/yonatanb/gcpOperator/logs/bucketList.txt"

# LBUCKET is for a large bucket if we want to avoid GCP to calculate it's size
LBUCKET=

    while IFS= read -r line
    do
        echo "$line"
	if [ "$line" = "$LBUCKET" ];
		then
			echo -e "Large Bucket. Skipping \n"
	else 
		RESULT=`/snap/bin/gsutil du -s $line | awk '{print $1}'`
		if [ "$RESULT" = "0" ];
			then
				echo -e "Deleting ${BUCKET} \n"
				`/snap/bin/gsutil rb $line`
			else
				echo -e "$(date -u) Not Deleting ${BUCKET} as it has files inside \n"
			fi
		fi
    done < "$input"
