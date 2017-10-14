# Chalice App

## Run
1. `cd` into this projects directory
2. Create a virtualenv using Python 3.6 callend `venv`
    * `virtualenv -p /path/to/python3.6 venv`
3. `source venv/bin/activate`
4. `pip install -r requirements.txt`
5. `chalice local`

---

## Endpoints
This app has three endpoints:
* `/status`
* `/public-api-info`
* `/upload`

### /status
Request using cURL:

`curl localhost:8000/status`

Response:
```
{
    "version": 0.1,
    "author": "aaron markey",
    "statuses": {
        "/status": "Okay",
        "/public-api-info": "Okay",
        "/upload": "Okay"
    }
}
```

### /public-api-info
Request using cURL:

`curl localhost:8000/public-api-info`

Response:
```
{
    "number-apis": 442,
    "avg-description-length": 33.002,
    "https-count": {
        "https": 348,
        "http": 94
    },
    "categories": {
        "Animals": 5,
        "Anime": 4,
        "Anti-Malware": 6,
        "Art & Design": 8,
        "Books": 4,
        "Business": 7,
        "Calendar": 6,
        "Cloud Storage & File Sharing": 5,
        "Continuous Integration": 3,
        "Cryptocurrency": 7,
        "Currency Exchange": 4,
        "Data Validation": 6,
        "Development": 39,
        "Documents & Productivity": 7,
        "Environment": 4,
        "Events": 3,
        "Finance": 6,
        "Food & Drink": 14,
        "Fraud Prevention": 5,
        "Games & Comics": 25,
        "Geocoding": 27,
        "Government": 6,
        "Health": 10,
        "Jobs": 14,
        "Machine Learning": 6,
        "Math": 2,
        "Music": 18,
        "News": 6,
        "Open Data": 32,
        "Open Source Projects": 3,
        "Patent": 3,
        "Personality": 7,
        "Photography": 9,
        "Science": 12,
        "Security": 3,
        "Shopping": 1,
        "Social": 23,
        "Sports & Fitness": 15,
        "Text Analysis": 4,
        "Tracking": 2,
        "Transportation": 47,
        "University": 1,
        "URL Shorteners": 4,
        "Vehicle": 3,
        "Video": 10,
        "Weather": 6
    },
    "auth-types": {
        "None": 218,
        "apiKey": 136,
        "OAuth": 81,
        "X-Mashape-Key": 7
    },
    "tld_count": {
        ".ceo": 1,
        ".org": 32,
        ".com": 240,
        ".io": 36,
        ".me": 2,
        ".net": 12,
        ".html": 12,
        ".nl": 3,
        ".uk": 4,
        ".info": 6,
        ".cz": 3,
        ".xml": 1,
        ".guru": 1,
        ".0": 4,
        ".md": 2,
        ".php": 3,
        ".tv": 2,
        ".in": 5,
        ".xyz": 3,
        ".json": 1,
        ".co": 4,
        ".fr": 2,
        ".sg": 1,
        ".nl&type=json": 1,
        ".eu": 2,
        ".gov": 20,
        ".br": 3,
        ".us": 1,
        ".pdf": 2,
        ".ai": 2,
        ".sh": 1,
        ".fm": 1,
        ".am": 1,
        ".au": 2,
        ".ca": 4,
        ".nz": 2,
        ".it": 1,
        ".php?action=help": 1,
        ".ly": 1,
        ".aspx?QryDS=API00": 1,
        ".es": 2,
        ".de": 1,
        ".md#api-endpoints": 1,
        ".is": 1,
        ".travel": 1,
        ".aspx": 2,
        ".be": 1,
        ".shtml": 1,
        ".fi": 1,
        ".no": 1,
        ".rio": 1,
        ".se": 1,
        ".ch": 1,
        ".swiss": 1
    }
}
```

### /upload
Request using cURL:
```
curl -X POST \
-H 'Content-Type: application/x-www-form-urlencoded' \
--data-binary '@<ABSOULTE/PATH/TO/PNG/FILE>' \
localhost:8000/upload
```

Response:
```
{
    "image-location": "https://s3.amazonaws.com/chalice-app/2017-10-14T13:51:42.043871.png"
}
```

---

## Notes

### General
* Everything specific to the version of the API and the environment it lives in 
is located in the enviroment.py file. This is to make it easy to adapt the app
to different AWS settings.

### /public-api-info
This endpoint generates aggregated data about the API listed at 
[github.com/toddmotto/public-apis](https://github.com/toddmotto/public-apis).

It will try to make a request and convert the response to the needed JSON. Then
it'll loop through each API given in the list and generate a number of data points 
about the list of APIs. 

**Room for improvement**

Move the repeating if/else statments in this endpoint's function into a single 
function in `utilities.py`

### /status
This endpoint will give the user a JSON representation of:
* Information about the API
* Statuses of the seperate endpoints

First, map the endpoints to their respective functions. Then, set the /status
endpoint to `ok` (Reasoning: If the user is hitting this endpoint successfully,
that is enough to know it is `ok`). 

Then for each item in the mapping, try to execute the endpoints function. If this
succeeds mark as `ok`, else mark as `unavailable`.

**Room for improvement**

Cannot get Chalice to make requests to itself successfully. Once that is figured
out, make HTTP requests to the endpoint maps.

### /upload
Endpoint allows user to upload a PNG to S3.

First, this endpoints function grabs the raw `byte` Python object from `raw_body`.
Then, create the client to interact with S3 using Amazon's boto3 library. Try to 
upload the image: if it fails, let the user know in the response. If the upload
is successful, generate the images URL on S3 and return that to the user in the
response.

The client uploads the file as a publicly readable item in S3, and it sets the 
Content-Type to `image/png` so the link generates a page openable in a browser
instead of a force download of the file.

The file name is created based on the date and time the file was uploaded, this
will stop naming collisions of file in the S3 bucket in most cases. 

**Room for improvement**

Check the MIME-type of the file passed into the request: if it is not a PNG,
reject it. This will make sure:
* Users are only uploading PNGs
* The link will always work correctly. Currently, the link depends on the image
being a PNG

---

## Other
Please look at the documentation available in the source files for more 
information.
