import environment as env
import boto3

# Possible services statuses to be returned by /status.
service_statuses = {
    'unavailable': 'Unavailable',
    'not_found': 'Not Found',
    'ok': 'Okay'
}


def generate_status_response(statuses):
    """
    Generate dictionary for /status response.

    ARGS
    ----
    statuses: dict
        A dictionary of statuses.

    RETURNS
    -------
    dict
        The response to be sent back to the user.
    """
    return {
        'version': env.API_VERSION,
        'author': env.API_AUTHOR,
        'statuses': statuses
    }


def s3_client():
    """
    Create S3 client.

    RETURNS
    -------
    boto3.Client
        A client that can be used to upload files to S3.
    """
    return boto3.client(
        's3',
        aws_access_key_id=env.AWS_ACCES_ID,
        aws_secret_access_key=env.AWS_ACCESS_KEY
    )
