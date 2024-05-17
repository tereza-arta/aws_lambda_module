import json
import os

def lambda_handler(event, context):
    print('Message from tf_lambda function...')
    
    lf_env_var = os.environ.get("KEY")
    return {
        'statusCode': 200,
        'body': json.dumps('Value of key is: ' + lf_env_var)
    }
