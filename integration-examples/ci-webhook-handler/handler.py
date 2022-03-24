import json
import base64
import atexit
import time

import boto3
from boto3.dynamodb.conditions import Key, Attr
from botocore.exceptions import ClientError

import signalfx

def ciwebhook(event, context):
    # event time
    etime = time.time()

    # validate json in body
    try:
        ebody = json.loads(event['body'])
    except Exception:
        body = {
            "message" : "Malformed JSON Input",
        }
        response = {"statusCode": 400, "body": json.dumps(body)}
        return response

    # parse input parameters
    try:
        environment = ebody['environment']
        buildId = ebody['buildId']
        buildStep = ebody['buildStep']
        eType = ebody['eventType']
        eStatus = ebody['status']
    except Exception:
        body = {
            "message" : "Missing Input Parameters",
            "body" : ebody
        }
        response = {"statusCode": 400, "body": json.dumps(body)}
        return response

    # create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name='us-east-1'
    )

    # Pull SFx Realm, Token from Secrets Manager
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId='SignalFx/Ingest'
        )
        secret = json.loads(get_secret_value_response['SecretString'])
        SignalFxRealm = str(secret['SignalFxRealm']).strip()
        SignalFxIngestToken = str(secret['SignalFxToken']).strip()
    except Exception as e:
        body = {
            "message" : "Cannot Initialize: Token Not Found",
            "body" : ebody
        }
        response = {"statusCode": 500, "body": json.dumps(body)}
        return response

    # create client for SignalFx ingest
    sfx = signalfx.SignalFx(api_endpoint='https://api.%s.signalfx.com' % (SignalFxRealm),
        ingest_endpoint='https://ingest.%s.signalfx.com' % (SignalFxRealm),
        stream_endpoint='https://stream.%s.signalfx.com' % (SignalFxRealm))
    ingest = sfx.ingest(SignalFxIngestToken)
    atexit.register(ingest.stop)

    # connect to database
    dynamodb = boto3.resource('dynamodb')
    dyntable = dynamodb.Table('webhookEventsTable')

    # lookup environment/build
    lookup = dyntable.query(KeyConditionExpression=Key('buildId').eq(buildId))
    litems = lookup['Items']

    report_build = False

    # respond to event type
    if eType == "start_build":
        # ensure this build ID is new
        if len(litems) > 0:
            body = {
                "message" : "Error: duplicate buildId",
                "body" : ebody
            }
            response = {"statusCode": 400, "body": json.dumps(body)}
            return response

        # push start build event to ingest
        evInfo = ebody
        evInfo.pop('eventType')
        ingest.send_event(
            category='USER_DEFINED',
            event_type='build started',
            dimensions=evInfo
        )

        evInfo = ebody
        evInfo['evtimestamp'] = int(etime * 1000.0)
        dyntable.put_item(Item = evInfo)
        if eStatus == "failed":
            report_build = True
            lookup = dyntable.query(KeyConditionExpression=Key('buildId').eq(buildId))
            litems = lookup['Items']

    elif eType == "build_step":
        # ensure this build ID is not new
        if len(litems) == 0:
            body = {
                "message" : "Error: build_step for unregistered build",
                "body" : ebody
            }
            response = {"statusCode": 400, "body": json.dumps(body)}
            return response

        # record build step to dynamo table
        evInfo = ebody
        evInfo['evtimestamp'] = int(etime * 1000.0)
        dyntable.put_item(Item = evInfo)

        if eStatus == "failed":
            report_build = True

    elif eType == "build_complete":
        # ensure this build ID is not new
        if len(litems) == 0:
            body = {
                "message" : "Error: build_complete for unregistered build",
                "body" : ebody
            }
            response = {"statusCode": 400, "body": json.dumps(body)}
            return response

        # push build complete event to ingest
        evInfo = ebody
        evInfo.pop('eventType')
        ingest.send_event(
            category='USER_DEFINED',
            event_type='build complete',
            dimensions=evInfo
        )
        report_build = True

    if report_build is True:
        # purge
        with dyntable.batch_writer() as batch:
            for item in litems:
                ditem = {}
                ditem['buildId'] = item['buildId']
                ditem['buildStep'] = item['buildStep']
                batch.delete_item(Key=ditem)

        # add build_complete record to list
        evInfo = ebody
        evInfo['evtimestamp'] = int(etime * 1000.0)
        litems.append(evInfo)

        sorted_events = sorted(litems, key=lambda k: k['evtimestamp'])

        # send metrics for each increment for "middle" steps
        last = sorted_events[0]
        step_gauges = []
        for step_event in sorted_events[1:]:
            step_time = step_event['evtimestamp'] - last['evtimestamp']
            # dimensionalize metrics on environment and build_step only
            # (assuming buildId is unique to a single build run)
            step_gauges.append( {
                'metric': 'build_system.step_time_ms',
                'value' : int(step_time),
                'dimensions': {'environment' : step_event['environment'],
                             'build_step' : step_event['buildStep'],
                             'status' : step_event['status']}
                })
            last = step_event
        # send whole build time for "complete event"
        build_time = evInfo['evtimestamp'] - sorted_events[0]['evtimestamp']
        step_gauges.append({
            'metric' : 'build_system.build_time_ms',
            'value': int(build_time),
            'dimensions': {'environment' : evInfo['environment'],
                           'status' : evInfo['status']}
            })
        ingest.send(gauges=step_gauges)

    body = {
        "message": "Go Serverless v2.0! Your function executed successfully!",
        "input": event,
    }

    response = {"statusCode": 200, "body": json.dumps(body)}

    return response
