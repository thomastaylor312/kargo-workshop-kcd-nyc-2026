# Akuity Facilitator Notes


## AWS Account
This workshop requires access to an AWS account with permissions to manage Lambdas and S3 buckets.

Participants without their own account can make use the Demo AWS account for participants, an isolated sandbox. 

### Akuity Employee Access

To get access to the AWS account, work with Ken or Eddie.

### IAM User

You will need to enable/create an AWS Access Key for the user `kcd-workshop-user` prior to the workshop. This user already has all the policies and roles needed for this workshop.


### Teardown

1) Delete AWS access key above (leave the IAM user but without active creds)
2) Run `scripts/teardown_all.sh` **after listing particpants** in the script. This will teardown the lambdas & buckets created during event.