import urllib3
import random
import threading
import sys
import time
import json

build_delay_min = 60
build_delay_max = 300

build_stepdelay_min = 10
build_stepdelay_max = 50

build_nsteps_min = 2
build_nsteps_max = 5

# failure rate 1 out of every n
step_failure_rate_1_per = 20

global gwebhookurl
global genvironment
global gpoolmgr

gpoolmgr = None
gwebhookurl = None
genvironment = None

def fake_build():
    bsteps = random.randint(build_nsteps_min, build_nsteps_max)
    buildId = 'build' + str(random.randint(0,65536))
    for step in range(bsteps):
        buildStep = 'step' + str(step)
        body = {}
        body['environment'] = genvironment
        body['buildId'] = buildId
        body['buildStep'] = buildStep
        body['status'] = 'success'
        if 1 == random.randint(1, step_failure_rate_1_per):
            body['status'] = 'failed'
        if step == 0:
            body['eventType'] = 'start_build'
        elif step == (bsteps - 1):
            body['eventType'] = 'build_complete'
        else:
            body['eventType'] = 'build_step'
        bodyJson = json.dumps(body)
        print('sending data to url %s:' % (gwebhookurl))
        print('   %s' % (bodyJson))
        resp = gpoolmgr.request("POST", gwebhookurl, timeout=30,
                headers={'Content-Type': 'application/json'},
                body=bodyJson)
        print("resp = %s" % (resp.data.decode()))
        if body['status'] == 'failed':
            return
        time.sleep(random.randint(build_stepdelay_min,build_stepdelay_max))


if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit('Usage %s <lambda_url> <environment>')

    gwebhookurl = sys.argv[1]
    genvironment = sys.argv[2]
    gpoolmgr = urllib3.PoolManager()

    while True:
        x = threading.Thread(target=fake_build)
        x.start()
        time.sleep(random.randint(build_delay_min,build_delay_max))
