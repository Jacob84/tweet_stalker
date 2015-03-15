# tweet-stalker
Tweet stalker is a test application that features topic recognition over Twitter lists.

![alt tag](https://raw.github.com/jacob84/tweet-stalker/master/media/example.png)

## System areas
 - **Ruby application that holds also a BackboneJS application.**
 - **Python microservice hosting NLTK associated features made with Flask.**

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
