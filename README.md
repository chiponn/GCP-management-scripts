This project is used to help reduce GCP costs by performing the following: 
1. Shutting down instances daily
2. Shutting down K8S clusters
3. Removing instances that were not in use for the last 20 days
4. Notifying users prior instance deletions (using Zapier webhook)
5. Removing K8S disks for instances that were already removed
6. Removing external reserved IP addresses that are not attached to any gcp instance
7. Removing empty buckets 


# The project has two directories: 
Scripts - Shell scripts that are designed to perform the actions above

logs - Contains the output from each script and also contains text files that help ignore instances from shutting down, ignore K8S clusters to be shut down, ignore removing specific instances, ignore removing specific external IPs, ignore searching through huge buckets. 


# How to use? 
1. As all scripts are used by gcloud client, please download and install first from here - https://cloud.google.com/sdk/install.
2. Place both directories under the same path. 
3. Add to crontab when would you like the script run. A crontab example can be found in the project's root directory. 
* If you use it, please make sure to change the path accordingly.
** You can open crontab with "$ crontabe -e" command and simply past the content inside.
