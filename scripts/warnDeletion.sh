#!/usr/bin/env bash
##############################################################################################################################
# Script designed to delete all instances that were not used in the last 20 days.          |         Designed by Yonatan Brand
##############################################################################################################################

export GCE_PROJECT=support-prod-157422
export WEBHOOK_URL=
#############################################################

        for INSTANCE in `/snap/bin/gcloud compute instances list --project ${GCE_PROJECT} --filter="Status:Terminated" | awk '{ print $1 }' | sed -e "1d"`;do
                RESULT=`/snap/bin/gcloud logging read "resource.type=gce_instance AND jsonPayload.event_subtype=compute.instances.stop AND ${INSTANCE}" --freshness="17d" --limit 1 --format json | jq ".[] | .timestamp"`
                echo $RESULT
                ZONE=`/snap/bin/gcloud compute instances list --project ${GCE_PROJECT} | grep -E "^${INSTANCE} " | awk '{print $2}'`
#               echo $ZONE
                if [ "$RESULT" = "" ]
                        then
                                if grep -Fxq ${INSTANCE} /home/yonatanb/gcpOperator/logs/storageStayOn.txt;then
                                        echo -e "$(date -u)  ${INSTANCE} has immunity. Won't be deleted \n"
                                else
					echo -e "$(date -u) sending ${INSTANCE} Sheriff warning.\n"
                                        USER=`/snap/bin/gcloud logging read "resource.type=gce_instance AND jsonPayload.event_subtype=compute.instances.insert AND ${INSTANCE}" --freshness="1000d" --limit=1 --format json | jq ".[] | .jsonPayload .actor .user"`
                                        LASTSD=`/snap/bin/gcloud logging read "resource.type=gce_instance AND jsonPayload.event_subtype=compute.instances.stop AND ${INSTANCE}" --freshness "20d" --limit 1 --format json | jq ".[] | .timestamp"`
                                        curl -d "{\"user\":${USER},\"instance\":\"${INSTANCE}\",\"time\": ${LASTSD}}" "${WEBHOOK_URL}"

                                fi
                fi
done
#############################################################
