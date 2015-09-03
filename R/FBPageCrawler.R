for (package in c('devtools', 'httr', 'rjson', 'httpuv', 'stringr')) { 
  if (!require(package, character.only=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

if(!require("Rfacebook")){
  install_github("WUNSG/Rfacebook/Rfacebook")
  require(Rfacebook)
}

FBPageCrawler <- function(){
  # STEP 1: Get fackebook token to access data. I need a crossplatform version of winDialog and winDialogString otherwise this only works on Windows
  winDialog(type = "ok", "Make sure you have already signed into Facebook.\n\nWhen  browser opens, please click 'Get Access Token' twice. You DO NOT need to select/check any boxes for a public feed.\n\n After pressing OK, swich over to your now open browser.")
  browseURL("http://developers.facebook.com/tools/explorer/?method=GET&path=100002667499585")
  token <- winDialogString("When browser opens, please click 'Get Access Token' twice and copy/paste token below", "")
  
  if (length(token) == 0) {
    winDialog(type = "ok", "Crawler stopped.")
    stop('Crawler stopped. \n\n')
  }
  
  # STEP 2: Get facebook ID. This can be a fanpage or whatever e.g. https://www.facebook.com/adidasSG
  tID <- winDialogString("Please enter FB page link below:", "https://www.facebook.com/adidasSG")
  
  if (length(tID) == 0) {
    winDialog(type = "ok", "Crawler stopped.")
    stop('Crawler stopped. \n\n')
  }
  
  ID <- gsub(".*com/", "", tID)
  
  # STEP 3: How far back do you want get data for? Format should be YYYY-MM-DD
  repeat{
    since <- winDialogString("Please enter a START (older) date for how roughly far back to gather data from using this format: yyyy-mm-dd", "2015-01-01")  
    if (length(since) == 0) {
      winDialog(type = "ok", "Crawler stopped.")
      stop('Crawler stopped. \n\n')
    }
  
    until <- winDialogString("Please enter a END (nearer) date using this format: yyyy-mm-dd", "2015-03-01")
    if (length(until) == 0) {
      winDialog(type = "ok", "Crawler stopped.")
      stop('Crawler stopped. \n\n')
    }
    
    if (until <= since){      
      winDialog(type = "ok", "START date later or equals to END date, please edit the dates. ")
    } 
    else {
      break
    }
  }
  
  max.post <-as.numeric(winDialogString("Enter maximum posts to crawl within the period", "100"))
  if (length(max.post) == 0) {
    winDialog(type = "ok", "Crawler stopped.")
    stop('Crawler stopped. \n\n')
  }
  
  #Extract information about a public Facebook post
  page <- getPage(page=ID, token=token, n=max.post, 
                  since=since, until=until)
  
  if (!exists("page")) {
    winDialog(type = "ok", "Crawler stopped.")
    stop('Error in access token, Crawler stopped. \n\n')
  }
  
  page[, 4] <- as.POSIXct(page[, 4], format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
  attr(page[, 4], "tzone") <- "Singapore"
  
  #Extract impression and reach information for all posts
  if (winDialog(type = "yesno", "Crawl impression and reach statistics?") == "YES"){
    for (i in 1:length(page$id)){
      print(paste("Crawling impression and reach statistics from post", i, "of", length(page$id), "posts..."))    
      
      #impressions
      insights <- getInsights(object_id=page[i, "id"], token=token, metric='post_impressions_by_paid_non_paid', period='lifetime')
      page[i, "total_impressions"] <- insights[insights$variable == "total", "value"]
      page[i, "unpaid_impressions"] <- insights[insights$variable == "unpaid", "value"]
      page[i, "paid_impressions"] <- insights[insights$variable == "paid", "value"]
      
      #reach
      insights <- getInsights(object_id=page[i, "id"], token=token, metric='post_impressions_by_paid_non_paid_unique', period='lifetime')
      page[i, "total_reach"] <- insights[insights$variable == "total", "value"]
      page[i, "unpaid_reach"] <- insights[insights$variable == "unpaid", "value"]
      page[i, "paid_reach"] <- insights[insights$variable == "paid", "value"]
    }
  }
    
  
  fileName <- str_c(c(ID, "-page-", since, "to", until, ".csv"), collapse = "")
  write.csv(page, fileName)
  winDialog(type = "ok", paste(nrow(page), "page posts saved in\n\n ", getwd(), "/", fileName))
  
  if (winDialog(type = "yesno", "Download comments?") == "YES"){
    #extract all comments from extracted page posts
    post.df <- data.frame()
    for (i in 1:length(page$id)){
      if(page$comments_count[i]> 0){
        print(paste("Crawling comments from post", i, "of", length(page$id), "posts..."))    
        post <- getPost(post=page$id[i], n=2000, token=token)
        post.df <- rbind(post.df, post$comments)
      }
    }
    
    if (!exists("post.df")) {
      winDialog(type = "ok", "Error in access token, Crawler stopped.")
      stop('Error in access token, Crawler stopped. \n\n')
    }
        
    #convert post timings to Singapore time (GMT+8)
    post.df[, 4] <- as.POSIXct(post.df[, 4], format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
    attr(post.df[, 4], "tzone") <- "Singapore"
    
    fileName <- str_c(c(ID, "-comments-", since, "to", until, ".csv"), collapse = "")
    write.csv(post.df, fileName)  
    
    winDialog(type = "ok", paste(nrow(post.df), "page comments saved in\n\n ", getwd(), "/", fileName))
  }
  
  winDialog(type = "ok", "Facebook crawl job completed.")    
  return(list(page, post.df))
}

