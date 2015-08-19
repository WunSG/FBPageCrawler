FBPageCrawler
=====

FBPageCrawler crawls public pages in Facebook. It allows you to download posts and comments from any public Facebook page in .csv files.

---

#### Installation
Simply copying the following lines of code in your R terminal should to install 
everything you need to run `FBPageCrawler` on your computer: 

```{r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("WUNSG/FBPageCrawler")

require(FBPageCrawler)

```

`FBPageCrawler` requires the installation of the latest versions of following packages 
on [CRAN](http://cran.r-project.org/):

1. [`httr`](http://cran.r-project.org/web/packages/httr/index.html)
2. [`rjson`](http://cran.r-project.org/web/packages/rjson/index.html)
3. [`httpuv`](https://cran.r-project.org/web/packages/httpuv/index.html)
4. [`stringr`](https://cran.r-project.org/web/packages/stringr/index.html)
5. [`RFacebook`](https://cran.r-project.org/web/packages/Rfacebook/index.html)

---

#### Usage
To start the Facebook crawler, simply run this line of code in your R console:

```{r}
FBPageCrawler()
```
You will see a window with instructions to sign into a facebook account. 

![Screenshot sign in message](https://cloud.githubusercontent.com/assets/8413284/9349904/7752ecac-467e-11e5-912d-515b3aab5772.JPG)

After clicking on OK, a dialog box appears.

![Token Dialog Box](https://cloud.githubusercontent.com/assets/8413284/9349902/77511418-467e-11e5-933b-4b4e305a1911.JPG)

At the same time, the Facebook Graph API Explorer page would be opened in the browser. If the Access Token is not showing, you will need to click on the 'Get Token' button twice. 

![FB Graph API Explorer](https://cloud.githubusercontent.com/assets/8413284/9349903/77515176-467e-11e5-98bc-e01b3803b10e.JPG)

After entering your access token, a dialog box will ask fo rthe Facebook page link. 

![FB Page Link](https://cloud.githubusercontent.com/assets/8413284/9349906/7758e79c-467e-11e5-8c1f-42157bff9c42.JPG)

After which, enter the start and end date of the period you would like to crawl the Facebook posts from. 

![Start Date](https://cloud.githubusercontent.com/assets/8413284/9349905/7757ba02-467e-11e5-9cb4-ad11df7ecb82.JPG)
![End Date](https://cloud.githubusercontent.com/assets/8413284/9349907/775d0f84-467e-11e5-9fcd-78213e2fc333.JPG)

Enter the maximum number of posts you would like to crawl from this period. 

![Max Posts](https://cloud.githubusercontent.com/assets/8413284/9349911/77a2317c-467e-11e5-97e3-c7049577a8d8.JPG)

When all posts are crawled, a message box will appear indicating the location and name of the file containing the crawled posts. 

![Posts](https://cloud.githubusercontent.com/assets/8413284/9349912/77a4c004-467e-11e5-9930-3402ef9b45f6.JPG)

A message box will then as if you want to crawl the comments from the crawled posts. 

![Comments Question](https://cloud.githubusercontent.com/assets/8413284/9349913/77a65aae-467e-11e5-8dc1-28c84c4e7da4.JPG)

When all comments are crawled, a message box will appear indicating the location and name of the file containing the crawled comments.

![Comments](https://cloud.githubusercontent.com/assets/8413284/9349909/7786bb7c-467e-11e5-9f07-a8587f8cfa62.JPG)

---

