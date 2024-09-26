# Auto Scaling Lifecycle Hooks

As your Auto Scaling group scale-out or scale-in your EC2 instances, you may want to perform custom actions before they start accepting traffic or before they get terminated. Auto Scaling Lifecycle Hooks allow you to perform custom actions during these stages. 

For example, during the scale-out event of your ASG, you want to make sure that new EC2 instances download the latest code base from the repository and that your EC2 user data has completed before it starts accepting traffic. This way, the new instances will be fully ready and will quickly pass the load balancer health check when they are added as targets. Another example is this – during the scale-in event of you ASG, suppose your instances upload data logs to S3 every minute. You may want to pause the instance termination for a certain amount of time to allow the EC2 to upload all data logs before it gets completely terminated. 


Lifecycle Hooks give you greater control of your EC2 during the launch and terminate events. The following diagram shows the transitions between the EC2 instance states with lifecycle hooks.

![alt text](https://td-mainsite-cdn.tutorialsdojo.com/wp-content/uploads/2020/05/Image-1-1.png)

1. The Auto Scaling group responds to a scale-out event and provisions a new EC2 instance. 

2. The lifecycle hook puts the new instance on Pending:Wait state. The instance stays in this paused state until you continue with the “CompleteLifecycleAction” operation or the default wait time of 3600 seconds is finished. For example, you can create a script that runs during the creation of the instance to download and install the needed packages for your application. Then the script can call the “CompleteLifecycleAction” operation to move the instance to the InService state. Or you can just wait for your configured timeout and the instance will be moved to the InService state automatically.

3. The instance is put to InService state. If you configured a load balancer for this Auto Scaling group, the instance will be added as targets and the load balancer will begin the health check. After passing the health checks, the instance will receive traffic.

4. The Auto Scaling group responds to a scale-in event and begins terminating an instance. 

5. The instance is taken out of the load balancer target. The lifecycle hook puts the instance on Terminating:Wait state. For example, you can set a timeout of 2 minutes on this section to allow your instance to upload any data files inside it to S3. After the timeout, the instance is moved to the next state.

6. Auto scaling group completes the termination of the instance.

During the paused state (either launch or terminate), you can do more than just run custom scripts or wait for timeouts. CloudWatch Events receives the scaling action and you can define a CloudWatch Events Target to invoke a Lambda function that can perform a pre-configured task. You can also configure a notification target for the lifecycle hook so that you will receive a message when the scaling event occurs.