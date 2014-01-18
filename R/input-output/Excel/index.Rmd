[**efg's R Notes:  Input/Output**](../index.html)

Reading Excel Files
===================

This page shows several examples of reading an Excel file into a data.frame.

Recall [**Sample.csv**](Sample.csv) file created using *writeLines*.  [View this csv on GitHub](https://github.com/EarlGlynn/earlglynn.github.io/blob/master/R/input-output/readcsv-writecsv/Sample.csv).

This CSV file was loaded into Excel .xlsx (Excel 2010) and .xls (Excel 2003) files.  Download [**Sample.xlsx**](Sample.xlsx) or [**Sample.xls**](Sample.xls).

Reading Excel files into R can be problematic.  Since I have not found one package that works with all Excel files, I show three approaches below:

1. XLConnect Package: readWorksheetFromFile (uses Java)
-------------------------------------------------------

```
# If using 64-bit Java, must use 64-bit R.

# Avoid Java out-of-memory error for large Excel files.
# See p. 16, http://cran.r-project.org/web/packages/XLConnect/vignettes/XLConnect.pdf
options (java.parameters = "-Xmx1024m")
library(XLConnect)

d1 <- readWorksheetFromFile("Sample.xlsx", sheet=1)    # .xls or .xlsx
dim(d1)
#[1] 4 5

str(d1)
#'data.frame':   4 obs. of  5 variables:
# $ Grade : chr  "A" "B" "F" "B"
# $ Age   : num  23 56 NA 35
# $ Code  : chr  "ABC" "DEF" NA "XYZ"
# $ Amount: num  48.98 2.72 0 3.14
# $ Start : POSIXct, format: "2014-01-01" "2014-01-02" NA "2014-01-05"

d1
#  Grade Age Code  Amount      Start
#1     A  23  ABC 48.9820 2014-01-01
#2     B  56  DEF  2.7183 2014-01-02
#3     F  NA <NA>  0.0000       <NA>
#4     B  35  XYZ  3.1416 2014-01-05
```

2. gdata Package: read.xls (uses PERL)
--------------------------------------

```
library(gdata)

d2 <- read.xls("Sample.xlsx", sheet=1)    # .xls or .xlsx
dim(d2)
#[1] 4 5

str(d2)
#'data.frame':   4 obs. of  5 variables:
# $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
# $ Age   : int  23 56 NA 35
# $ Code  : Factor w/ 4 levels "","ABC","DEF",..: 2 3 1 4
# $ Amount: num  48.98 2.72 0 3.14
# $ Start : int  41640 41641 NA 41644

d2a <- read.xls("Sample.xlsx", sheet=1, as.is=TRUE)
str(d2a)
#'data.frame':   4 obs. of  5 variables:
# $ Grade : chr  "A" "B" "F" "B"
# $ Age   : int  23 56 NA 35
# $ Code  : chr  "ABC" "DEF" "" "XYZ"
# $ Amount: num  48.98 2.72 0 3.14
# $ Start : int  41640 41641 NA 41644
```

3. RODBC package:  sqlFetch or sqlQuery
---------------------------------------

Note:  odbcConnectExcel is only usable with 32-bit Windows and 32-bit ODBC.

```
channel  <- odbcConnectExcel("Sample.xls")       # Excel 2003 and earlier
#channel <- odbcConnectExcel2007("Sample.xlsx")  # Excel 2007 and later
sqlTables(channel)

d3 <- sqlFetch(channel, "Sample")  # Worksheet name
#'data.frame':   4 obs. of  5 variables:
# $ Grade : Factor w/ 3 levels "A","B","F": 1 2 3 2
# $ Age   : num  23 56 NA 35
# $ Code  : Factor w/ 3 levels "ABC","DEF","XYZ": 1 2 NA 3
# $ Amount: num  48.98 2.72 0 3.14
# $ Start : POSIXct, format: "2014-01-01" "2014-01-02" NA "2014-01-05"

d3a <- sqlQuery(channel, paste("SELECT Code,Amount,Start,Age,Grade",
                               "FROM [Sample$]",
                               "WHERE Grade = 'B'"),
                as.is=TRUE)
dim(d3a)
#[1] 2 5

str(d3a)
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

