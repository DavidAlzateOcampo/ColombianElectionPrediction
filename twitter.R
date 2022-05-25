install.packages('httr',repos='http://cran.r-project.org', dependencies=TRUE)
install.packages('twitteR',repos='http://cran.r-project.org', dependencies=TRUE)
install.packages('ROAuth',repos='http://cran.r-project.org', dependencies=TRUE)
install.packages('tm',repos='http://cran.r-project.org', dependencies=TRUE)
install.packages('wordcloud',repos='http://cran.r-project.org', dependencies=TRUE)## Revisar
install.packages('RColorBrewer',repos='http://cran.r-project.org', dependencies=TRUE)
devtools::install_github("joyofdata/RTwitterAPI")


library(httr)
library(RCurl)
library(twitteR)
library(ROAuth)
library(tm)
library(wordcloud)
library(RColorBrewer)
library(XML)
# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

## Set values from Connection.R

twitCred <- OAuthFactory$new(
  consumerKey = apiKey, 
  consumerSecret = apiSecret,
  requestURL = reqURL,
  accessURL = accessURL, 
  authURL = authURL
)
twitCred$handshake(
  cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")
)
## Old way of executing with registerTwitterOAuth, this is deprecated so We will not use it in our developments
## registerTwitterOAuth(twitCred)
##To enable the connection, please direct your web browser to: 


## New way to register the R application 
setup_twitter_oauth(consumer_key = apiKey, consumer_secret = apiSecret, access_token = apiAccessToken, access_secret = apiAccessTokenSecret)

mh370 <- searchTwitter("RecuperemosBogotá", since = "2015-08-08", until = "2015-10-20", n = 1000)
mh370_text = sapply(mh370, function(x) x$getText())
mh370_corpus = Corpus(VectorSource(mh370_text))

TunClaraStr <-"TunjuelitoVotaClara"
TunClara <- searchTwitter(TunClaraStr, since = "2015-08-08", until = "2015-10-20", n = 1000)
TunClaraText = sapply(TunClara, function(x) x$getText())
homeDir <- "/home/ce.gomez10/data/"
fileName<- paste(homeDir,TunClaraStr,".csv",sep="")
write.table(TunClaraText,file=fileName,sep='|',col.names = FALSE )

extractTwitt <- function(hashTag,size=1000,dateIni="2015-08-08",dateEnd="2015-10-20"){
  twittersFound <- searchTwitter(hashTag, since = dateIni, until = dateEnd, n = size)
  twittersFoundText = sapply(twittersFound, function(x) x$getText())
  homeDir <- "/home/ce.gomez10/data/"
  if (size != length(twittersFoundText)) {
    size <- length(twittersFoundText) 
  }
  fileName<- paste(homeDir,hashTag,"_",as.character(size),".csv",sep="")
  write.table(twittersFoundText,file=fileName,sep='|',col.names = FALSE )
}


