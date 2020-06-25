#!/bin/bash
######################################################################################################
# Script designed to stop / start all instances in a GCP project. |         Designed by Yonatan Brand
######################################################################################################

export OPERATION=${1}
export GCE_PROJECT=support-prod-157422
export AUTO=${3}

#############################################################

PROJECT_OPERATION () {
#  echo -e "${OPERATION}ing consul server\n"
#  CONSUL_OPERATION
#  `echo ${OPERATION} | tr '[:lower:]' '[:upper:]'`_INSTANCE_GROUP
#  sleep 10
  echo -e "$(date -u)	${OPERATION}ing all servers\n"
  for INSTANCE in `/snap/bin/gcloud compute instances list --project ${GCE_PROJECT} --filter="Status:Running" | awk '{ print $1 }' | sed -e "1d"`;do
    if grep -Fxq ${INSTANCE} /home/yonatanb/gcpOperator/logs/stay_on.txt;then
      echo -e "${INSTANCE} wont be powered off\n"
    else
      ZONE=`/snap/bin/gcloud compute instances list --project ${GCE_PROJECT} | grep -E "^${INSTANCE} " | awk '{print $2}'`
      echo "$(date -u)	${OPERATION}ing ${INSTANCE} (${ZONE}) in ${GCE_PROJECT}"
      /snap/bin/gcloud compute instances ${OPERATION} ${INSTANCE} --project ${GCE_PROJECT} --zone ${ZONE} > /dev/null 2>&1  &
    fi
  done
}
#############################################################
#############################################################
VERIFY () {
  read -p "Are you sure you want to ${OPERATION} all instances in ${GCE_PROJECT}?, enter Y for yes: "
  if [[ ${REPLY} =~ ^[Yy]$ ]];then
    for i in $(seq 10 -1 1);do
      echo -n $i..." "
      sleep 1
    done
    echo -e "\n"
  else
    exit 1
  fi
}
#############################################################
#############################################################
if [[ -z "${OPERATION}" || -z "${GCE_PROJECT}" ]];then
  echo -e "\nUsage: resource_management.sh <stop/start> <GCE project>\n"
  exit 1
fi
#############################################################
#############################################################
case "${OPERATION}" in
  'stop')
    if [[ -z "${AUTO}" ]];then
      VERIFY
    fi
    PROJECT_OPERATION "stop" "${GCE_PROJECT}"
  ;;
  'start')
    if [[ -z "${AUTO}" ]];then
      VERIFY
    fi
    PROJECT_OPERATION "start" "${GCE_PROJECT}"
  ;;
  *)
    echo -e "\nUsage: resource_management.sh <stop/start> <GCE project>\n"
  ;;
esac
#############################################################
