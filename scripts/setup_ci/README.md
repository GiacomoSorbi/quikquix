All the scripts need to be run from this directory

You will need [an IAM user with programmatic access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)

## Deploy
1. Authenticate against AWS

```
export AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
```

2. Run the deploy script
```
./deploy.sh 
```
## Destroy (destroys all resources that the deploy script creates)
1. Authenticate against AWS 
```
export AWS_ACCESS_KEY_ID=<your-aws-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key>
```

2. Run the destroy script
```
./destroy.sh
```
