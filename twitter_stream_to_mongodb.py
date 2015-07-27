'''
Author: John Letteboer
Date: July 26, 2015
---------------------------------------------
Stream Twitter Timeline and save into MongDB
---------------------------------------------
Stream Twitter Timeline with a filter and save the tweets into MongoDB 
'''

# Import libraries
import json
import pymongo
import tweepy

# Setting the variables and will be used in the stream listener.
consumer_key = "your consumer key"
consumer_secret = "your consumer secret key"
access_key = "your access token"
access_secret = "your access token secret"

# creating an OAuthHandler instance. Into this we pass our consumer token and secret.
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
# Set access token
auth.set_access_token(access_key, access_secret)
# Construct the API instance
api = tweepy.API(auth)

class CustomStreamListener(tweepy.StreamListener):
    """
    tweepy.StreamListener is a class provided by tweepy used to access the Twitter 
    Streaming API. It allows us to retrieve tweets in real time.
    """
    def __init__(self, api):
        self.api = api
        super(tweepy.StreamListener, self).__init__()
        
        # Connecting to MongoDB and use the database twitter.
        self.db = pymongo.MongoClient().twitter

    def on_data(self, tweet):
        '''
        This will be called each time we receive stream data and store the tweets 
        into the datascience collection.
        '''
        self.db.datascience.insert(json.loads(tweet))

    def on_error(self, status_code):
        # This is called when an error occurs
        print >> sys.stderr, 'Encountered error with status code:', status_code
        return True # Don't kill the stream

    def on_timeout(self):
        # This is called if there is a timeout
        print >> sys.stderr, 'Timeout.....'
        return True # Don't kill the stream


# Create our stream object
sapi = tweepy.streaming.Stream(auth, CustomStreamListener(api))

'''
The track parameter is an array of search terms to stream. In this example I will use 
filter to stream all tweets containing the hashtags datascience and datascientist.
''' 
sapi.filter(track=['#datascience', '#datascientist'])
