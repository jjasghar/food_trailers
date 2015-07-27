#!/bin/sh
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,PublicIpAddress,State.Name,Tags[?Key==`Name`].Value[]]' --output text | sed '$!N;s/\n/ /' | grep running
