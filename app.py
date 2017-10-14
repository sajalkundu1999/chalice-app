from chalice import Chalice
import utilities as util
import requests
import json
import boto3
from datetime import datetime

import environment as env

app = Chalice(app_name='app')


@app.route('/public-api-info', methods=['GET'])
def public_api_info():
    """
    Get interesting aggregated stats about publicly available APIs.
    """
    apis_url = 'https://raw.githubusercontent.com/toddmotto/public-apis/master/json/entries.json'

    # get data from URL
    try:
        apis = requests.get(apis_url)
    except:
        return {'error': 'Could not load data.'}

    # get data as a Python dict
    data = None
    try:
        data = json.loads(apis.text)
    except:
        return{'error': 'Could not parse data.'}

    api_count = 0
    api_categories = {}
    api_http = {
        'https': 0,
        'http': 0
    }
    api_auth = {
        'None': 0
    }
    api_tlds = {}
    description_len_total = 0

    # loop through each item and gather data
    for api in data['entries']:
        api_count += 1
        description_len_total += len(api['Description'])
        if api['Category'] in api_categories:
            api_categories[api['Category']] += 1
        else:
            api_categories[api['Category']] = 1

        if not api['Auth']:
            api_auth['None'] += 1
        elif api['Auth'] in api_auth:
            api_auth[api['Auth']] += 1
        else:
            api_auth[api['Auth']] = 1

        if api['HTTPS']:
            api_http['https'] += 1
        else:
            api_http['http'] += 1

        tld = api['Link'].split('.')[-1].split('/')[0]
        if '.' + tld in api_tlds:
            api_tlds['.' + tld] += 1
        else:
            api_tlds['.' + tld] = 1
    description_len_avg = round(float(description_len_total) / api_count, 3)

    # return dict of data
    return {
        'number-apis': api_count,
        'avg-description-length': description_len_avg,
        'https-count': api_http,
        'categories': api_categories,
        'auth-types': api_auth,
        'tld_count': api_tlds
    }


@app.route('/upload', methods=['POST'], content_types=['application/x-www-form-urlencoded'])
def upload():
    """
    Upload a PNG to S3.
    """
    # get uploaded file
    image_data = app.current_request.raw_body

    # create client
    client = util.s3_client()

    file_name = (str(datetime.now()) + '.png').replace(' ', 'T')

    # upload file
    try:
        client.put_object(
            ACL='public-read',
            Body=image_data,
            Bucket=env.AWS_BUCKET,
            Key=file_name,
            ContentType='image/png'
        )
    except:
        return {'error': 'Could not upload image to S3.'}

    # generate image location
    image_location = 'https://s3.amazonaws.com/{}/{}'.format(
        env.AWS_BUCKET,
        file_name
    )

    # return image location
    return {'image-location': image_location}


@app.route('/status', methods=['GET'])
def status():
    """
    Check available endpoints and their respective status.
    """
    endpoint_map = {
        '/public-api-info': public_api_info,
        '/upload': upload
    }
    statuses = {}

    # assign self
    statuses['/status'] = util.service_statuses['ok']

    # assign others
    for name, function in endpoint_map.items():
        try:
            function()
        except:
            statuses[name] = util.service_statuses['unavailable']
        else:
            statuses[name] = util.service_statuses['ok']
    return util.generate_status_response(statuses)
