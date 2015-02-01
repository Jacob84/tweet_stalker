from bs4 import BeautifulSoup

from flask import Flask, request, jsonify

import urllib.request

from urlnlpprocessor import *

app = Flask(__name__)

@app.route("/")
def hello():
    js = request.get_json()

    nlpProcessor = NlpProcessor()
    urlNlpProcessor = UrlNlpProcessor()

    url_results = []

    result = nlpProcessor.process(js['tweet_text'])

    for entity in js['entities']:
        url_result = urlNlpProcessor.process(entity['url'])
        url_results.append(url_result.to_json())

    json_result = {  "result": result, "entities_result": url_results  }

    print (json_result)

    return jsonify(results=json_result) , 200, {'Content-Type': 'application/json; charset=utf-8'}

if __name__ == "__main__":
    app.run(debug = True)
