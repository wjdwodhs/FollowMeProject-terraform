import boto3
import datetime

ec2 = boto3.client('ec2')
sns = boto3.client('sns')
sns_topic_arn = 'arn:aws:sns:ap-northeast-2:516268691817:ec2-monitoring-alert'

def lambda_handler(event, context):
    instances = ec2.describe_instances(Filters=[
        {'Name': 'tag:Name', 'Values': ['followme-instance']}
    ])['Reservations']

    for reservation in instances:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            name = 'Backup-' + instance_id + '-' + datetime.datetime.now().strftime('%Y%m%d%H%M%S')

            image = ec2.create_image(
                InstanceId=instance_id,
                Name=name,
                NoReboot=True
            )

            image_id = image['ImageId']
            print(f"AMI created: {image_id}")


            try:
                sns.publish(
                    TopicArn=sns_topic_arn,
                    Subject='[EC2 백업 완료]',
                    Message=f"백업된 EC2: {instance_id}\n생성된 AMI: {image_id}"
                )
            except Exception as e:
                print(f"[ERROR] SNS Publish Failed: {e}")
