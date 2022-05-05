# Terraform

1 step - ``Installing or updating the latest version of the AWS CLI``
``` 
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html 
```

2 step - ``Installing or updating the latest version terraform``
``` 
https://www.terraform.io/downloads
``` 
3 step 

``Go to AWS in "IAM" - Add user - Copy "Access key" and "Secret accsess key"``

4 step 
```
aws configure
```

paste
```
1) "Access key":
2) "Secret accsess key":
3) "Region name": eu-west-1
4) "Format": json
```

5 step - ``change files``

6 step 
```
terraform init
terraform plan
etc...
```


# Addition
## import

``aws_instance``
```
terraform import aws_instance.inet-test1 i-03cf4000000
```
``aws_security_group``
```
terraform import aws_security_group.index-private-full-acces sg-01e5cfaxxxx
```