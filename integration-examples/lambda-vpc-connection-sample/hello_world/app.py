import json
import requests


def lambda_handler(event, context):
    x = requests.get('https://w3schools.com/python/demopage.htm')
    print(x.text)

    return {
        'statusCode': 200,
        'body': json.dumps(x.text)
    }
