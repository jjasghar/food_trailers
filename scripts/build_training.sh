#!/bin/sh
# Builds training instances in EC2
USAGE="Usage: $0 [number] [tag]"
NUMHOSTS=$1
TAG=$2

# You can change these to suit your needs
AMI="ami-47d8d777"
INSTANCE_TYPE="c4.xlarge"
KEY_NAME="gramsay_bot"

if [ "$#" -ne 2 ]; then
  echo $USAGE
  exit 1
fi

for host in $(aws ec2 run-instances --image-id $AMI --count $NUMHOSTS --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids "sg-d11d0db4" "sg-401e0e25" "sg-541e0e31" "sg-9d1e0ef8" --subnet-id subnet-da4bd3bf | jq -r ".Instances|.[].InstanceId"); do
  echo "Created instance: $host"
  echo "Tagging $host with \"$TAG\""
  aws ec2 create-tags --resources $host --tags "Key=Name,Value=\"$TAG\""
done
