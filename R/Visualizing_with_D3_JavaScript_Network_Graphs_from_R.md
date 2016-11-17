# Visualizing with D3 JavaScript Network Graphs from R
John Letteboer  
`r Sys.Date()`  

Hi all, I want to visualize some of my courses I've followed by year. I have found [D3 JavaScript Network Graphs from R](http://christophergandrud.github.io/networkD3/) with some nice and cool visualizations.

In this post I will describe how I transform my data for creating the RadialNetwork and DiagonalNetwork visualizations.

# Loading and have a look at the data
First off all I had a Excel file with some of my followed some courses since 2013. I've saved it to a csv file ```courses.csv```. Let have a look of the file.


```r
setwd("~/Documents")
courses <- read.csv("courses.csv", sep=";",header=TRUE, stringsAsFactors = FALSE)
head(courses)
```

```
##   year    month                                         course     type
## 1 2013 December  Excel 2007-2010 Expert: Analyse en rapportage in-class
## 2 2014  Januari                   Business Analysis (Vijfhart) in-class
## 3 2014 November      Business Intelligence & Analytics (Cibit) in-class
## 4 2014 December         Big Data Fundamentals (IIR Trainingen) in-class
## 5 2015  Januari Datameer Big Data Certified Analyst (Datameer) in-class
## 6 2015 Februari The Python programming language (AT Computing) in-class
```

```r
str(courses)
```

```
## 'data.frame':	25 obs. of  4 variables:
##  $ year  : int  2013 2014 2014 2014 2015 2015 2015 2015 2015 2015 ...
##  $ month : chr  "December" "Januari" "November" "December" ...
##  $ course: chr  "Excel 2007-2010 Expert: Analyse en rapportage" "Business Analysis (Vijfhart)" "Business Intelligence & Analytics (Cibit)" "Big Data Fundamentals (IIR Trainingen)" ...
##  $ type  : chr  "in-class" "in-class" "in-class" "in-class" ...
```

Oke, we have a data.frame of 25 observation of 4 variables (year, month, course and type). Since both visualizations are based on tree diagrams we need to create a tree from my ```data.frame```. After some searching on the internet I've found the package [data.tree](https://cran.r-project.org/web/packages/data.tree/vignettes/data.tree.html). In this package there is a paragraph called "Create a tree from a ```data.frame```".

# Let's start to create a tree from my courses
Load the library.

```r
library(data.tree)
```

The ```data.frame``` is a table and each row is a leaf. We create a path from root to leaf and save that into the ```data.frame``` as new column ```pathString```.
Define the hierarchy (Year|Month|Type|Course)

```r
courses$pathString <- paste("courses",courses$year,courses$month,courses$type,courses$course, sep= "|")
head(courses)
```

```
##   year    month                                         course     type
## 1 2013 December  Excel 2007-2010 Expert: Analyse en rapportage in-class
## 2 2014  Januari                   Business Analysis (Vijfhart) in-class
## 3 2014 November      Business Intelligence & Analytics (Cibit) in-class
## 4 2014 December         Big Data Fundamentals (IIR Trainingen) in-class
## 5 2015  Januari Datameer Big Data Certified Analyst (Datameer) in-class
## 6 2015 Februari The Python programming language (AT Computing) in-class
##                                                                      pathString
## 1  courses|2013|December|in-class|Excel 2007-2010 Expert: Analyse en rapportage
## 2                    courses|2014|Januari|in-class|Business Analysis (Vijfhart)
## 3      courses|2014|November|in-class|Business Intelligence & Analytics (Cibit)
## 4         courses|2014|December|in-class|Big Data Fundamentals (IIR Trainingen)
## 5  courses|2015|Januari|in-class|Datameer Big Data Certified Analyst (Datameer)
## 6 courses|2015|Februari|in-class|The Python programming language (AT Computing)
```

After we have created the ```pathString``` we need to convert it to a node, with the package ```data.tree``` is that very easy.

```r
coursesTree <- as.Node(courses, pathDelimiter = "|")
coursesTree
```

```
##                                                                 levelName
## 1  courses                                                               
## 2   ¦--2013                                                              
## 3   ¦   °--December                                                      
## 4   ¦       °--in-class                                                  
## 5   ¦           °--Excel 2007-2010 Expert: Analyse en rapportage         
## 6   ¦--2014                                                              
## 7   ¦   ¦--Januari                                                       
## 8   ¦   ¦   °--in-class                                                  
## 9   ¦   ¦       °--Business Analysis (Vijfhart)                          
## 10  ¦   ¦--November                                                      
## 11  ¦   ¦   °--in-class                                                  
## 12  ¦   ¦       °--Business Intelligence & Analytics (Cibit)             
## 13  ¦   °--December                                                      
## 14  ¦       °--in-class                                                  
## 15  ¦           °--Big Data Fundamentals (IIR Trainingen)                
## 16  ¦--2015                                                              
## 17  ¦   ¦--Januari                                                       
## 18  ¦   ¦   °--in-class                                                  
## 19  ¦   ¦       °--Datameer Big Data Certified Analyst (Datameer)        
## 20  ¦   ¦--Februari                                                      
## 21  ¦   ¦   °--in-class                                                  
## 22  ¦   ¦       °--The Python programming language (AT Computing)        
## 23  ¦   ¦--May                                                           
## 24  ¦   ¦   °--online                                                    
## 25  ¦   ¦       ¦--The Data Scientist's Toolbox (Coursera)               
## 26  ¦   ¦       °--Quick start to JavaScript Volume 1,2 & 3 (Pluralsight)
## 27  ¦   ¦--June                                                          
## 28  ¦   ¦   °--online                                                    
## 29  ¦   ¦       ¦--R Programming (Cousera)                               
## 30  ¦   ¦       ¦--Big Data Analytics with Tableau (Pluralsight)         
## 31  ¦   ¦       ¦--Data Analysis Fundamentals with Tableau (Pluralsight) 
## 32  ¦   ¦       °--Getting and Cleaning Data (Coursera)                  
## 33  ¦   ¦--November                                                      
## 34  ¦   ¦   ¦--online                                                    
## 35  ¦   ¦   ¦   °--Exploratory Data Analysis (Coursera)                  
## 36  ¦   ¦   °--in-class                                                  
## 37  ¦   ¦       °--Applied Statistics and data analysis (Tridata)        
## 38  ¦   °--December                                                      
## 39  ¦       ¦--online                                                    
## 40  ¦       ¦   ¦--Reproducible Research (Coursera)                      
## 41  ¦       ¦   °--R Programming (Data-Mania)                            
## 42  ¦       °--in-class                                                  
## 43  ¦           °--Scrum Master                                          
## 44  °--2016                                                              
## 45      ¦--Januari                                                       
## 46      ¦   ¦--online                                                    
## 47      ¦   ¦   °--Statistical Inference (Coursera)                      
## 48      ¦   °--in-class                                                  
## 49      ¦       ¦--Using Splunk 6 (Splunk)                               
## 50      ¦       ¦--Searching and Reporting with Splunk 6 (Splunk)        
## 51      ¦       ¦--Creating Splunk 6.3 Knowledge Objects (Splunk)        
## 52      ¦       °--Splunk Tutorial (Splunk)                              
## 53      ¦--April                                                         
## 54      ¦   °--in-class                                                  
## 55      ¦       °--JavaScript (Vijfhart)                                 
## 56      °--August                                                        
## 57          °--online                                                    
## 58              ¦--JavaScript (Codecademy)                               
## 59              °--Intro to Descriptive Statistics (Udemy)
```

The last thing we need is a list-to-list structure before we can plot the two networkD3 visulizatios

```r
coursesTreeList <- ToListExplicit(coursesTree, unname =TRUE)
```

# Plot the two visulizatios

```r
library(networkD3)
diagonalNetwork(List=coursesTreeList, 
                fontSize = 13, 
                fontFamily = "OpenSans-Light", 
                nodeStroke = "orange",
                linkColour = "#AAA",
                opacity = 0.9)
```

<!--html_preserve--><div id="htmlwidget-e3c57f903803a3752004" style="width:864px;height:768px;" class="diagonalNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-e3c57f903803a3752004">{"x":{"root":{"name":"courses","children":[{"name":"2013","children":[{"name":"December","children":[{"name":"in-class","children":[{"name":"Excel 2007-2010 Expert: Analyse en rapportage","course":"Excel 2007-2010 Expert: Analyse en rapportage","month":"December","type":"in-class","year":2013}]}]}]},{"name":"2014","children":[{"name":"Januari","children":[{"name":"in-class","children":[{"name":"Business Analysis (Vijfhart)","course":"Business Analysis (Vijfhart)","month":"Januari","type":"in-class","year":2014}]}]},{"name":"November","children":[{"name":"in-class","children":[{"name":"Business Intelligence & Analytics (Cibit)","course":"Business Intelligence & Analytics (Cibit)","month":"November","type":"in-class","year":2014}]}]},{"name":"December","children":[{"name":"in-class","children":[{"name":"Big Data Fundamentals (IIR Trainingen)","course":"Big Data Fundamentals (IIR Trainingen)","month":"December","type":"in-class","year":2014}]}]}]},{"name":"2015","children":[{"name":"Januari","children":[{"name":"in-class","children":[{"name":"Datameer Big Data Certified Analyst (Datameer)","course":"Datameer Big Data Certified Analyst (Datameer)","month":"Januari","type":"in-class","year":2015}]}]},{"name":"Februari","children":[{"name":"in-class","children":[{"name":"The Python programming language (AT Computing)","course":"The Python programming language (AT Computing)","month":"Februari","type":"in-class","year":2015}]}]},{"name":"May","children":[{"name":"online","children":[{"name":"The Data Scientist's Toolbox (Coursera)","course":"The Data Scientist's Toolbox (Coursera)","month":"May","type":"online","year":2015},{"name":"Quick start to JavaScript Volume 1,2 & 3 (Pluralsight)","course":"Quick start to JavaScript Volume 1,2 & 3 (Pluralsight)","month":"May","type":"online","year":2015}]}]},{"name":"June","children":[{"name":"online","children":[{"name":"R Programming (Cousera)","course":"R Programming (Cousera)","month":"June","type":"online","year":2015},{"name":"Big Data Analytics with Tableau (Pluralsight)","course":"Big Data Analytics with Tableau (Pluralsight)","month":"June","type":"online","year":2015},{"name":"Data Analysis Fundamentals with Tableau (Pluralsight)","course":"Data Analysis Fundamentals with Tableau (Pluralsight)","month":"June","type":"online","year":2015},{"name":"Getting and Cleaning Data (Coursera)","course":"Getting and Cleaning Data (Coursera)","month":"June","type":"online","year":2015}]}]},{"name":"November","children":[{"name":"online","children":[{"name":"Exploratory Data Analysis (Coursera)","course":"Exploratory Data Analysis (Coursera)","month":"November","type":"online","year":2015}]},{"name":"in-class","children":[{"name":"Applied Statistics and data analysis (Tridata)","course":"Applied Statistics and data analysis (Tridata)","month":"November","type":"in-class","year":2015}]}]},{"name":"December","children":[{"name":"online","children":[{"name":"Reproducible Research (Coursera)","course":"Reproducible Research (Coursera)","month":"December","type":"online","year":2015},{"name":"R Programming (Data-Mania)","course":"R Programming (Data-Mania)","month":"December","type":"online","year":2015}]},{"name":"in-class","children":[{"name":"Scrum Master","course":"Scrum Master","month":"December","type":"in-class","year":2015}]}]}]},{"name":"2016","children":[{"name":"Januari","children":[{"name":"online","children":[{"name":"Statistical Inference (Coursera)","course":"Statistical Inference (Coursera)","month":"Januari","type":"online","year":2016}]},{"name":"in-class","children":[{"name":"Using Splunk 6 (Splunk)","course":"Using Splunk 6 (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Searching and Reporting with Splunk 6 (Splunk)","course":"Searching and Reporting with Splunk 6 (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Creating Splunk 6.3 Knowledge Objects (Splunk)","course":"Creating Splunk 6.3 Knowledge Objects (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Splunk Tutorial (Splunk)","course":"Splunk Tutorial (Splunk)","month":"Januari","type":"in-class","year":2016}]}]},{"name":"April","children":[{"name":"in-class","children":[{"name":"JavaScript (Vijfhart)","course":"JavaScript (Vijfhart)","month":"April","type":"in-class","year":2016}]}]},{"name":"August","children":[{"name":"online","children":[{"name":"JavaScript (Codecademy)","course":"JavaScript (Codecademy)","month":"August","type":"online","year":2016},{"name":"Intro to Descriptive Statistics (Udemy)","course":"Intro to Descriptive Statistics (Udemy)","month":"August","type":"online","year":2016}]}]}]}]},"options":{"height":null,"width":null,"fontSize":13,"fontFamily":"OpenSans-Light","linkColour":"#AAA","nodeColour":"#fff","nodeStroke":"orange","textColour":"#111","margin":{"top":null,"right":null,"bottom":null,"left":null},"opacity":0.9}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
radialNetwork(List=coursesTreeList, 
                fontSize = 13,
                fontFamily = "OpenSans-Light",
                nodeStroke = "orange",
                opacity = 0.9)
```

<!--html_preserve--><div id="htmlwidget-fd25569b9b8f1bff6964" style="width:864px;height:768px;" class="radialNetwork html-widget"></div>
<script type="application/json" data-for="htmlwidget-fd25569b9b8f1bff6964">{"x":{"root":{"name":"courses","children":[{"name":"2013","children":[{"name":"December","children":[{"name":"in-class","children":[{"name":"Excel 2007-2010 Expert: Analyse en rapportage","course":"Excel 2007-2010 Expert: Analyse en rapportage","month":"December","type":"in-class","year":2013}]}]}]},{"name":"2014","children":[{"name":"Januari","children":[{"name":"in-class","children":[{"name":"Business Analysis (Vijfhart)","course":"Business Analysis (Vijfhart)","month":"Januari","type":"in-class","year":2014}]}]},{"name":"November","children":[{"name":"in-class","children":[{"name":"Business Intelligence & Analytics (Cibit)","course":"Business Intelligence & Analytics (Cibit)","month":"November","type":"in-class","year":2014}]}]},{"name":"December","children":[{"name":"in-class","children":[{"name":"Big Data Fundamentals (IIR Trainingen)","course":"Big Data Fundamentals (IIR Trainingen)","month":"December","type":"in-class","year":2014}]}]}]},{"name":"2015","children":[{"name":"Januari","children":[{"name":"in-class","children":[{"name":"Datameer Big Data Certified Analyst (Datameer)","course":"Datameer Big Data Certified Analyst (Datameer)","month":"Januari","type":"in-class","year":2015}]}]},{"name":"Februari","children":[{"name":"in-class","children":[{"name":"The Python programming language (AT Computing)","course":"The Python programming language (AT Computing)","month":"Februari","type":"in-class","year":2015}]}]},{"name":"May","children":[{"name":"online","children":[{"name":"The Data Scientist's Toolbox (Coursera)","course":"The Data Scientist's Toolbox (Coursera)","month":"May","type":"online","year":2015},{"name":"Quick start to JavaScript Volume 1,2 & 3 (Pluralsight)","course":"Quick start to JavaScript Volume 1,2 & 3 (Pluralsight)","month":"May","type":"online","year":2015}]}]},{"name":"June","children":[{"name":"online","children":[{"name":"R Programming (Cousera)","course":"R Programming (Cousera)","month":"June","type":"online","year":2015},{"name":"Big Data Analytics with Tableau (Pluralsight)","course":"Big Data Analytics with Tableau (Pluralsight)","month":"June","type":"online","year":2015},{"name":"Data Analysis Fundamentals with Tableau (Pluralsight)","course":"Data Analysis Fundamentals with Tableau (Pluralsight)","month":"June","type":"online","year":2015},{"name":"Getting and Cleaning Data (Coursera)","course":"Getting and Cleaning Data (Coursera)","month":"June","type":"online","year":2015}]}]},{"name":"November","children":[{"name":"online","children":[{"name":"Exploratory Data Analysis (Coursera)","course":"Exploratory Data Analysis (Coursera)","month":"November","type":"online","year":2015}]},{"name":"in-class","children":[{"name":"Applied Statistics and data analysis (Tridata)","course":"Applied Statistics and data analysis (Tridata)","month":"November","type":"in-class","year":2015}]}]},{"name":"December","children":[{"name":"online","children":[{"name":"Reproducible Research (Coursera)","course":"Reproducible Research (Coursera)","month":"December","type":"online","year":2015},{"name":"R Programming (Data-Mania)","course":"R Programming (Data-Mania)","month":"December","type":"online","year":2015}]},{"name":"in-class","children":[{"name":"Scrum Master","course":"Scrum Master","month":"December","type":"in-class","year":2015}]}]}]},{"name":"2016","children":[{"name":"Januari","children":[{"name":"online","children":[{"name":"Statistical Inference (Coursera)","course":"Statistical Inference (Coursera)","month":"Januari","type":"online","year":2016}]},{"name":"in-class","children":[{"name":"Using Splunk 6 (Splunk)","course":"Using Splunk 6 (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Searching and Reporting with Splunk 6 (Splunk)","course":"Searching and Reporting with Splunk 6 (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Creating Splunk 6.3 Knowledge Objects (Splunk)","course":"Creating Splunk 6.3 Knowledge Objects (Splunk)","month":"Januari","type":"in-class","year":2016},{"name":"Splunk Tutorial (Splunk)","course":"Splunk Tutorial (Splunk)","month":"Januari","type":"in-class","year":2016}]}]},{"name":"April","children":[{"name":"in-class","children":[{"name":"JavaScript (Vijfhart)","course":"JavaScript (Vijfhart)","month":"April","type":"in-class","year":2016}]}]},{"name":"August","children":[{"name":"online","children":[{"name":"JavaScript (Codecademy)","course":"JavaScript (Codecademy)","month":"August","type":"online","year":2016},{"name":"Intro to Descriptive Statistics (Udemy)","course":"Intro to Descriptive Statistics (Udemy)","month":"August","type":"online","year":2016}]}]}]}]},"options":{"height":null,"width":null,"fontSize":13,"fontFamily":"OpenSans-Light","linkColour":"#ccc","nodeColour":"#fff","nodeStroke":"orange","textColour":"#111","margin":{"top":null,"right":null,"bottom":null,"left":null},"opacity":0.9}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

Well that look nice!! This package is great!!

This code can also be find on my [GitHub](https://github.com/jletteboer/networkx.nl/)

## SessionInfo

```r
sessionInfo()
```

```
## R version 3.3.2 (2016-10-31)
## Platform: x86_64-apple-darwin13.4.0 (64-bit)
## Running under: macOS Sierra 10.12.1
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] networkD3_0.2.13 data.tree_0.4.0 
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.8      visNetwork_1.0.2 digest_0.6.10    assertthat_0.1  
##  [5] R6_2.2.0         plyr_1.8.4       jsonlite_1.1     magrittr_1.5    
##  [9] evaluate_0.10    scales_0.4.1     stringi_1.1.2    rstudioapi_0.6  
## [13] rmarkdown_1.1    DiagrammeR_0.8.4 tools_3.3.2      stringr_1.1.0   
## [17] htmlwidgets_0.8  igraph_1.0.1     munsell_0.4.3    influenceR_0.1.0
## [21] yaml_2.1.14      colorspace_1.3-0 htmltools_0.3.5  knitr_1.15      
## [25] tibble_1.2
```
