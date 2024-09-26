#!/bin/bash
yum update -y
curl -sL https://rpm.nodesource.com/setup_lts.x|bash -
yum install nodejs -y
npm install -g pm2
pm2 update
cd /home/ec2-user
sleep 10
INSTANCE_ID=$(curl -s https://169.254.169.254/latest/meta-data/instance-id)
aws autoscaling complete-lifecycle-action --lifecylce-action-result CONTINUE --instance-id $INSTANCE_ID --lifecycle-hook-name test-hook --auto-scaling-group-name test-asg --region ap-south-1 || \ 
aws autoscaling complete-lifecycle-action --lifecylce-action-result ABANDON --instance-id $INSTANCE_ID --lifecycle-hook-name test-hook --auto-scaling-group-name test-asg --region ap-south-1