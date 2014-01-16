[**efg's R Notes:  Input/Output**](../index.html)

read.csv / write.csv
====================

This page shows several examples of reading a comma-separate-value (CSV) file into a data.frame.

Recall [**Sample.csv**](../../input-output/writelines-readLines/Sample.csv) file created using [*writeLines*](../../input-output/writeLines-readLines/index.html):

![gedit display of Sample.csv](../../input-output/writeLines-readLines/Sample-CSV-Gedit.jpg)

Find all the R code in this Gist, [R-IO-readcsv-writecsv.R](https://gist.github.com/EarlGlynn/8450305).

1. Read CSV file into data.frame
--------------------------------


```r
rawdata <- read.csv("Sample.csv")
rawdata
```

```
##   Grade Age Code Amount      Start
## 1     A  23  ABC 48.982 2014-01-01
## 2     B  56  DEF  2.718 2014-01-02
## 3     F  NA       0.000           
## 4     B  35  XYZ  3.142 2014-01-05
```

```r

dim(rawdata)  # dimensions
```

```
## [1] 4 5
```

```r
nrow(rawdata)  # number of rows
```

```
## [1] 4
```

```r
ncol(rawdata)  # number of columns
```

```
## [1] 5
```

```r

names(rawdata)  # column names
```

```
## [1] "Grade"  "Age"    "Code"   "Amount" "Start"
```

```r
row.names(rawdata)
```

```
## [1] "1" "2" "3" "4"
```

```r

str(rawdata)  # structure
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
##  $ Age   : int  23 56 NA 35
##  $ Code  : Factor w/ 4 levels "","ABC","DEF",..: 2 3 1 4
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : Factor w/ 4 levels "","2014-01-01",..: 2 3 1 4
```


R *head* and *tail* functions are useful to see the first few or last few rows of a data.frame.

Data types will be described below.

Notes:
* *read.csv2* is used in countries where a comma is used as a decimal point and fields are separated by semicolons. 
* *read.delim* reads tab-delimited data much like *read.csv* reads comma-delimited data.
* There is no write.delim function that corresponds to the write.csv function.  
* Functions read.table/write.table provide more general options, such as user-defined delimiters. 

2.  How to address elements of data.frame
-----------------------------------------

Columns of data.frame


```r
rawdata$Grade
```

```
## [1] A B F B
## Levels: A B F
```

```r
rawdata$Age
```

```
## [1] 23 56 NA 35
```

```r
rawdata$Score  # typo here!
```

```
## NULL
```


A data.frame can be indexed like a matrix:  *rawdata[rows, columns]*

Note:  indexing in R starts at 1.

```r
rawdata[2, 4]  # single element: row 2, column 4
```

```
## [1] 2.718
```

```r
rawdata[2, ]  # row 2
```

```
##   Grade Age Code Amount      Start
## 2     B  56  DEF  2.718 2014-01-02
```

```r
rawdata[, 4]  # column 4
```

```
## [1] 48.982  2.718  0.000  3.142
```

```r

rawdata[1:2, c(1, 3, 5)]  # first 2 rows of columns 1, 3 and 5
```

```
##   Grade Code      Start
## 1     A  ABC 2014-01-01
## 2     B  DEF 2014-01-02
```


Associate memory, hash, dictionary


```r
# Single element
rawdata["2", "Amount"]  # row name '2', 'Amount' column
```

```
## [1] 2.718
```

```r

# Rows with names '2' and '1', columns with names 'Start', 'Code' and 'Age'
rawdata[c("2", "1"), c("Start", "Code", "Age")]
```

```
##        Start Code Age
## 2 2014-01-02  DEF  56
## 1 2014-01-01  ABC  23
```


3.  Suppress factors while reading CSV file
-------------------------------------------


```r
# 'Factors' are stored as integers internally
rawdata$Code
```

```
## [1] ABC DEF     XYZ
## Levels:  ABC DEF XYZ
```

```r
as.integer(rawdata$Code)
```

```
## [1] 2 3 1 4
```

```r
as.character(rawdata$Code)
```

```
## [1] "ABC" "DEF" ""    "XYZ"
```

```r

# Re-read using stringsAsFactors=FALSE
rawdata <- read.csv("Sample.csv", stringsAsFactors = FALSE)
rawdata
```

```
##   Grade Age Code Amount      Start
## 1     A  23  ABC 48.982 2014-01-01
## 2     B  56  DEF  2.718 2014-01-02
## 3     F  NA       0.000           
## 4     B  35  XYZ  3.142 2014-01-05
```

```r
str(rawdata)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : chr  "A" "B" "F" "B"
##  $ Age   : int  23 56 NA 35
##  $ Code  : chr  "ABC" "DEF" "" "XYZ"
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : chr  "2014-01-01" "2014-01-02" "" "2014-01-05"
```


4.  Control data types while reading CSV file
---------------------------------------------


```r
rawdata <- read.csv("Sample.csv", colClasses = c("factor", "integer", "character", 
    "numeric", "Date"))
str(rawdata)
```

```
## 'data.frame':	4 obs. of  5 variables:
##  $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
##  $ Age   : int  23 56 NA 35
##  $ Code  : chr  "ABC" "DEF" "" "XYZ"
##  $ Amount: num  48.98 2.72 0 3.14
##  $ Start : Date, format: "2014-01-01" "2014-01-02" ...
```


5.  Data type suggestions
-------------------------

* Use "factor" for small, well-defined list of discrete values.
* Use "character" for strings that may need to be edited/modified/searched.
* The "best" format for Dates is [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601):  YYYY-MM-DD
* In vectors, integers take 4 bytes, numeric doubles take 8 bytes.

In 32-bit R:


```r
N <- 1000000L
object.size(rep(0L, N))  # a million integers
```

```
## 4000040 bytes
```

```r
object.size(rep(0, N))  # a million doubles
```

```
## 8000040 bytes
```


6.  Reading selected data from CSV
----------------------------------

*nrow* dictates number of rows to read.

*"NULL"* type in *colClasses* supprsses reading of data column


```r
selected <- read.csv("Sample.csv", nrow = 2, header = TRUE, colClasses = c("NULL", 
    "integer", "NULL", "numeric", "NULL"))
selected
```

```
##   Age Amount
## 1  23 48.982
## 2  56  2.718
```


This trick can be used to read selected columns from a mulitmillion-row file that would otherwise fill available memory.

7.  Writing CSV file from data.frame
------------------------------------

The default *write.csv* adds some information that may not be in the original file.


```r
# Default write.csv
write.csv(rawdata)  # echo to screen to review
```

```
## "","Grade","Age","Code","Amount","Start"
## "1","A",23,"ABC",48.982,2014-01-01
## "2","B",56,"DEF",2.7183,2014-01-02
## "3","F",NA,"",0,NA
## "4","B",35,"XYZ",3.1416,2014-01-05
```

```r
write.csv(rawdata, "Sample-Copy-Default.csv")  # write to file
```

*write.csv* defaults to including row.names and quotes around


```r
# Drop row names.
write.csv(rawdata, row.names = FALSE)  # echo to screen
```

```
## "Grade","Age","Code","Amount","Start"
## "A",23,"ABC",48.982,2014-01-01
## "B",56,"DEF",2.7183,2014-01-02
## "F",NA,"",0,NA
## "B",35,"XYZ",3.1416,2014-01-05
```

```r
write.csv(rawdata, "Sample-Copy-No-RowNames.csv", row.names = FALSE)

# Exactly the same as original file (for this case)
write.csv(rawdata, row.names = FALSE, quote = FALSE, na = "")  # echo to screen
```

```
## Grade,Age,Code,Amount,Start
## A,23,ABC,48.982,2014-01-01
## B,56,DEF,2.7183,2014-01-02
## F,,,0,
## B,35,XYZ,3.1416,2014-01-05
```

```r
write.csv(rawdata, "Sample-Copy-Exact.csv", row.names = FALSE, quote = FALSE, 
    na = "")
write.csv(rawdata, file("clipboard"), row.names = FALSE, quote = FALSE, na = "")  # Write to clipboard
```


