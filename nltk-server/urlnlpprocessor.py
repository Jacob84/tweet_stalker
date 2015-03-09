from textblob import TextBlob
from relevantcontentfinder import *
from httpclient import *
from flask import json
import datetime

class UrlNlpProcessorResult:
    def __init__(self, url):
        self.url = url

    def set_title(self, title):
        self.title = title

    def set_headings(self, first_headings, second_headings, third_headings):
        self.first_headings = first_headings
        self.second_headings = second_headings
        self.third_headings = third_headings

    def set_text(self, text):
        self.text = text

    def set_noun_phrases(self, noun_phrases):
        self.noun_phrases = list(set(noun_phrases))
        self.noun_phrases = sorted(self.noun_phrases, key=lambda r:r[1], reverse=True)[0:10]

    def set_times(self, total_time, download_time, parsing_time):
        self.total_time = total_time
        self.download_time = download_time
        self.parsing_time = parsing_time

    def to_json(self):
        data = {
            'url': self.url,
            'created_at'  : str(datetime.datetime.now()),
            'title': self.title,
            'first_headings' : self.first_headings,
            #'second_headings': self.second_headings,
            #'third_headings': self.third_headings,
            # 'text': self.text,
            'noun_phrases': self.noun_phrases,
            'download_time': self.download_time,
            'parsing_time': self.parsing_time,
            'method_time': self.total_time
        }

        return data

class NlpProcessor:
    def __init__(self):
        pass

    def process(self, text):
        textblob = TextBlob(text)
        noun_phrases = textblob.noun_phrases
        noun_phrases_importance = [(n, textblob.noun_phrases.count(n)) for n in noun_phrases]
        return noun_phrases_importance

class UrlNlpProcessor:
    def __init__(self):
        pass

    def process(self, url):
        try:
            start_method = time.time()

            content = HttpClient().get_html(url)
            relevant_text = RelevantContentRetriever().get_relevant_text(content.text)

            soup = BeautifulSoup(content.text)

            [s.extract() for s in soup('script')]

            headings1 = [s.string for s in soup.find_all('h1') if s.string is not None]
            headings2 = [s.string for s in soup.find_all('h2') if s.string is not None]
            headings3 = [s.string for s in soup.find_all('h3') if s.string is not None]

            lowered_headings = " ".join([h.lower() for h in headings1])

            noun_phrases_importance = NlpProcessor().process(relevant_text.text)

            noun_phrases_importance = list([(x, y + 5) if x.lower() in soup.title.string.lower() else (x,y) for (x,y) in noun_phrases_importance])
            noun_phrases_importance = list([(x, y + 5) if x.lower() in lowered_headings else (x,y) for (x,y) in noun_phrases_importance])

            end_method = time.time()

            result = UrlNlpProcessorResult(url)
            result.set_title(soup.title.string if soup.title is not None else "no title")
            result.set_headings(headings1, headings2, headings3)
            result.set_text(relevant_text.text)
            result.set_noun_phrases(noun_phrases_importance)
            result.set_times(end_method-start_method, content.time, relevant_text.time)

            return result
        except Exception as e:
            print (e)
            return self.__get_null_object(url)

    def __get_null_object(self, url):
        null_object = UrlNlpProcessorResult(url)
        null_object.set_title('')
        null_object.set_headings([], [], [])
        null_object.set_text('')
        null_object.set_noun_phrases([])
        null_object.set_times(0, 0, 0)

        return null_object
