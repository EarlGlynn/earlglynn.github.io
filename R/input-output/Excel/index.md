[**efg's R Notes:  Input/Output**](../index.html)

Reading Excel Files
===================

This page shows several examples of reading an Excel file into a data.frame.

Recall [**Sample.csv**](Sample.csv) file created using *writeLines*.  [View this csv on GitHub](https://github.com/EarlGlynn/earlglynn.github.io/blob/master/R/input-output/readcsv-writecsv/Sample.csv).

This CSV file was loaded into Excel .xlsx (Excel 2010) and .xls (Excel 2003) files.  Download [**Sample.xlsx**](Sample.xlsx) or [**Sample.xls**](Sample.xls).

Reading Excel files into R can be problematic.  Since I have not found one package that works with all Excel files, I show four approaches below. 

Find all the R code in this Gist, [R-IO-Excel.R](https://gist.github.com/EarlGlynn/8487321).

1. XLConnect Package: readWorksheetFromFile (uses Java)
-------------------------------------------------------

If using 64-bit Java, must use 64-bit R.


```r
# Avoid Java out-of-memory error for large Excel files.  See p. 16,
# http://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf
options(java.parameters = "-Xmx1024m")
library(XLConnect)
```

```
## XLConnect 0.2-7 by Mirai Solutions GmbH
## http://www.mirai-solutions.com ,
## http://miraisolutions.wordpress.com
```

```r

d1 <- readWorksheetFromFile("Sample.xlsx", sheet = 1)  # .xls or .xlsx
dim(d1)
```

```
## [1] 4 5
```

```r
str(d1)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : chr  "A" "B" "F" "B"
##  $ Age   : num  23 56 NA 35
##  $ Code  : chr  "ABC" "DEF" NA "XYZ"
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : POSIXct, format: "2014-01-01" "2014-01-02" ...
```

```r

d1
```

```
##   Grade Age Code Amount      Start
## 1     A  23  ABC 48.982 2014-01-01
## 2     B  56  DEF  2.718 2014-01-02
## 3     F  NA <NA>  0.000       <NA>
## 4     B  35  XYZ  3.142 2014-01-05
```


2. xlsx Package: read.xlsx or read.xlsx2 (uses Java)
-------------------------------------------------------

If using 64-bit Java, must use 64-bit R.

Read Excel file 2003 or earlier (.xls)

```r
library(xlsx)
```

```
## Loading required package: rJava
## Loading required package: xlsxjars
## 
## Attaching package: 'xlsx'
## 
## The following objects are masked from 'package:XLConnect':
## 
##     createFreezePane, createSheet, createSplitPane, getCellStyle,
##     getSheets, loadWorkbook, removeSheet, saveWorkbook,
##     setCellStyle, setColumnWidth
```

```r
d2 <- read.xlsx("Sample.xls", sheetIndex = 1)
dim(d2)
```

```
## [1] 4 5
```

```r
str(d2)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
##  $ Age   : num  23 56 NA 35
##  $ Code  : Factor w/ 3 levels "ABC","DEF","XYZ": 1 2 NA 3
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : Date, format: "2014-01-01" "2014-01-02" ...
```


Read Excel file 2007 or later (.xlsx)

```r
d2a <- read.xlsx("Sample.xlsx", sheetIndex = 1, stringsAsFactors = FALSE)
str(d2a)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : chr  "A" "B" "F" "B"
##  $ Age   : num  23 56 NA 35
##  $ Code  : chr  "ABC" "DEF" NA "XYZ"
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : Date, format: "2014-01-01" "2014-01-02" ...
```


3. gdata Package: read.xls (uses PERL)
--------------------------------------

64-bit ActivePerl Community Edition works on Windows with either 32-bit or 64-bit R.  [http://www.activestate.com/activeperl](http://www.activestate.com/activeperl).


```r
library(gdata)
```

```
## gdata: read.xls support for 'XLS' (Excel 97-2004) files ENABLED.
## 
## gdata: read.xls support for 'XLSX' (Excel 2007+) files ENABLED.
## 
## Attaching package: 'gdata'
## 
## The following object is masked from 'package:stats':
## 
##     nobs
## 
## The following object is masked from 'package:utils':
## 
##     object.size
```

```r

d3 <- read.xls("Sample.xls", sheet = 1)  # .xls or .xlsx
dim(d3)
```

```
## [1] 4 5
```

```r
str(d3)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
##  $ Age   : int  23 56 NA 35
##  $ Code  : Factor w/ 4 levels "","ABC","DEF",..: 2 3 1 4
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : Factor w/ 4 levels "","2014/01/01",..: 2 3 1 4
```

```r

d3a <- read.xls("Sample.xlsx", sheet = 1, as.is = TRUE)
dim(d3a)
```

```
## [1] 4 5
```

```r
str(d3a)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : chr  "A" "B" "F" "B"
##  $ Age   : int  23 56 NA 35
##  $ Code  : chr  "ABC" "DEF" "" "XYZ"
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : int  41640 41641 NA 41644
```


4. RODBC package:  sqlFetch or sqlQuery
---------------------------------------

Note:  "odbcConnectExcel is only usable with 32-bit Windows" with 32-bit R.

```
channel  <- odbcConnectExcel("Sample.xls")       # Excel 2003 and earlier
#channel <- odbcConnectExcel2007("Sample.xlsx")  # Excel 2007 and later
sqlTables(channel)

d4 <- sqlFetch(channel, "Sample")  # Worksheet name
#'data.frame':   4 obs. of  5 variables:
# $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
# $ Age   : num  23 56 NA 35
# $ Code  : Factor w/ 3 levels "ABC","DEF","XYZ": 1 2 NA 3
# $ Amount: num  48.98 2.72 0 3.14
# $ Start : POSIXct, format: "2014-01-01" "2014-01-02" NA "2014-01-05"

d4a <- sqlQuery(channel, paste("SELECT Code,Amount,Start,Age,Grade",
                               "FROM [Sample$]",
                               "WHERE Grade = 'B'"),
                as.is=TRUE)
dim(d4a)
#[1] 2 5

str(d4a)
#'data.frame':   2 obs. of  5 variables:
# $ Code  : chr  "DEF" "XYZ"
# $ Amount: num  2.72 3.14
# $ Start : chr  "2014-01-02 00:00:00" "2014-01-05 00:00:00"
# $ Age   : num  56 35
# $ Grade : chr  "B" "B"

close(channel)
```

My advice:  RODBC should only be used if you have an Excel file without holes, and with very regular numeric data. Without very regular data, RODBC can guess the wrong data types and cause other problems.

See [Madelaine's notes](http://research.stowers-institute.org/mcm/rmysql.html) for additional RODBC examples -- and some RMySQL examples.

*efg*, 2014-01-08
