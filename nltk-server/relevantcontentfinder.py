import re
import time
from bs4 import BeautifulSoup
from bs4.element import *

class RelevantContentResult:
    def __init__(self, points, depth_level, id, text, time = 0):
        self.id = id
        self.points = points
        self.text = text
        self.text_size = len(text)
        self.depth_level = depth_level
        self.time = time

class RelevantContentRetriever:
    def __init__(self, debug = False):
        self._results_list = []
        self._tags_without_text = [NavigableString, Comment]
        self._debug = debug

    def get_relevant_text(self, content):
        start_parsing = time.time()

        soup = BeautifulSoup(content)

        [s.extract() for s in soup('script')]
        [s.extract() for s in soup('style')]
        [s.extract() for s in soup('option')]

        self.__process_current_node__(soup.body)

        if self._debug:
            for node in self._results_list:
                print ("Points %i - TextSize %i - DepthLevel %i (ID: %s)"
                % (node.points, node.text_size, node.depth_level, node.id))

        if len(self._results_list) > 0:
            better_node = max(self._results_list, key=lambda r: r.points)
        else:
            better_node = RelevantContentResult(0, 0, '', '')

        end_parsing = time.time()

        better_node.time = end_parsing - start_parsing

        return better_node

    def __process_current_node__(self, node, depth_level = 0):
        children = node.children
        for node in children:
            try:
                if type(node) not in self._tags_without_text:
                    node_text = node.get_text().replace("\r", "")
                    node_text = node.get_text().replace("\n", "")
                    node_text = node.get_text().replace("\t", "")
                    node_text = re.sub(' +',' ', node_text)

                    self._results_list.append(
                        RelevantContentResult(
                            len(node_text) * depth_level if node_text is not None else 0,
                            depth_level,
                            node.get('id') if node.get('id') is not None else "",
                            node_text))

                    self.__process_current_node__(node, depth_level + 1)
            except Exception as e:
                print (e)
