import time
import urllib.request

class HttpClientResult:
    def __init__(self, text, time):
        self.text = text
        self.time = time

class HttpClient:

    def __init__(self):
        self.USER_AGENT = 'StalkingBird/0.1'
        self.DECODE_WITH = 'utf-8'

    def get_html(self, url):
        start_downloading = time.time()

        opener = urllib.request.build_opener()
        opener.addheaders = [('User-agent', self.USER_AGENT)]
        response = opener.open(url)
        content = str(response.read().decode(self.DECODE_WITH, "replace"))

        end_downloading = time.time()

        return HttpClientResult(content, end_downloading-start_downloading)
