import boto3

ec2_client = boto3.client('ec2', region_name="us-east-1")
instance_name_tag_value = "dev-server"
custom_ami_name = "amzon-linux-nodeapp-3"

def create_custom_ami():
    responses = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': [
                    instance_name_tag_value
                ],
            },
            {
                'Name': 'instance-state-name',
                'Values': [ "running" ],
            },
        ],
    )

    for response in responses['Reservations']:
        for instance in response['Instances']:
            ec2_client.create_image(InstanceId=instance['InstanceId'], Name=custom_ami_name)
            # print(instance['InstanceId'])
    
    waiter = ec2_client.get_waiter('image_available')
    waiter.wait(
        Filters = [
            {
                "Name": "name" ,
                "Values": [ custom_ami_name ]
            },
            {
                "Name": "state" ,
                "Values": [ "available" ]
            }
        ]
    )

try:
    create_custom_ami()
    print("AMI has been created successfully.")
except Exception:
    pass





    
