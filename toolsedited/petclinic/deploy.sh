#!/bin/bash
output=$(tower-cli job launch --job-template=petclinic --extra-vars="REGISTRY=${registry}")
if [[ $? -eq 0 ]]; then
   # get current job number
   currJob=$(echo "${output}" | awk '{print $1}' | tail -2 | head -1)
   echo "currJob number = ${currJob}"
   status=$(tower-cli job status ${currJob} | awk '{print $1}' | tail -2 | head -1)
   until [ $status == "successful" ] || [ $status == "failed" ]; do 
      echo -e "----------------------------"
      status=$(tower-cli job status ${currJob} | awk '{print $1}' | tail -2 | head -1)
      echo $status
      sleep 5
   done
   if [ $status == "successful" ]; then
      echo "Ansible job ran successfully"
   else
      echo "Ansible job failed"
      exit 1
   fi
else
exit -1
fi
