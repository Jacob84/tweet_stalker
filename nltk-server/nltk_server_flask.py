from bs4 import BeautifulSoup
from flask import Flask, request, jsonify
from urlnlpprocessor import *

import urllib.request
import json
import re

app = Flask(__name__)

debug_requests = True

@app.route("/")
def hello():
    js = request.get_json()

    if debug_requests:
        print ('request')
        print (js)
        print ("")

    nlpProcessor = NlpProcessor()
    urlNlpProcessor = UrlNlpProcessor()

    text = re.sub(r'https?:\/\/.*[\r\n]*', '', js['tweet_text'])
    text = re.sub(r'@(\w)*', '', text)
    text = text.replace('RT', '')

    result = nlpProcessor.process(text)
    url_results = []

    for entity in js['entities']:
        url_result = urlNlpProcessor.process(entity)
        for noun_phrase in url_result.noun_phrases:
            result.append(noun_phrase)
        url_results.append(url_result.to_json())

    result = list(set(result))
    result = sorted(result, key=lambda r:r[1], reverse=True)[0:10]
    result = { "result": result, "entities_result": url_results }

    json_result = json.dumps(result)

    if debug_requests:
        print ('result')
        print (json_result)
        print ("")

    return json_result , 200, {'Content-Type': 'application/json; charset=utf-8'}

if __name__ == "__main__":
    app.run(debug = True)
