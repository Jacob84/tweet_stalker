# tweet-stalker
**Tweet stalker is a web application that gathers information about specific groups of people via Twitter lists and using Natural Language Processing.**

![alt tag](https://raw.github.com/jacob84/tweet-stalker/master/media/capture.png)

## How it works

The application tracks the lists selected by the user, downloading their tweets. After downloaded and saved, they are
analyzed with Natural Language Processing algorithms to extract topics and meaning. If entities are found inside the
tweet, they are analyzed too. As their contents may vary both in structure and information, the most meaningful
container is extracted to perform the analysis and avoid noise. All the information is backed in a noSQL database.

![alt tag](https://raw.github.com/jacob84/tweet-stalker/master/media/example2.png)

## System areas
 - Ruby application that holds also a BackboneJS application.
 - Python microservice hosting NLTK and HTML parsing associated features made with Flask.

## Future
At the current stage, only on-demand tracking is done. The desired features are:
 - Download periodically tweets from the selected lists and perform NLP analysis.
 - Decent web application to show the feeds.
 - Automatic categorizing of the tweets and web push notifications.
 - More statistics (graphs of relations between accounts, etc) probably with D3.js
 
## Information to run the application
 - Development ruby version is 2.1.3
 - Mongo DB is used to store the information. A Vagrant VM is used and the configuration is partially stored in the vagrant folder.
 - To run the tests just type 'rspec'
