writeLines / readLines
======================

1. Create files for *read.csv* and *read.delim* examples
--------------------------------------------------------

This page shows how to create [**Sample.csv**](Sample.csv) and [**Sample.tsv**](Sample.tsv) files using *writeLines* for use in later examples of *read.csv* and *read.delim*.

Find all the R code in this Gist, [R-IO-writeLines-readLines.R](https://gist.github.com/EarlGlynn/8431150).

Let's first define some data in a vector of five character strings:


```r
data.lines.comma <- c("Grade,Age,Code,Amount,Start", "A,23,ABC,48.982,2014-01-01", 
    "B,56,DEF,2.7183,2014-01-02", "F,,,0,", "B,35,XYZ,3.1416,2014-01-05")
data.lines.comma
```

```
## [1] "Grade,Age,Code,Amount,Start" "A,23,ABC,48.982,2014-01-01" 
## [3] "B,56,DEF,2.7183,2014-01-02"  "F,,,0,"                     
## [5] "B,35,XYZ,3.1416,2014-01-05"
```


*writeLines* writes the strings to a comma-separated-value (CSV) text file:


```r
writeLines(data.lines.comma, "Sample.csv")
```


Many ASCII editors can display a CSV file, such as the graphic below from using the *gedit* editor:

![gedit display of Sample.csv](Sample-CSV-Gedit.jpg)


The R "global substitution" function, *gsub*, converts commas to tabs:


```r
data.lines.tab <- gsub(",", "\t", data.lines.comma)
data.lines.tab
```

```
## [1] "Grade\tAge\tCode\tAmount\tStart" "A\t23\tABC\t48.982\t2014-01-01" 
## [3] "B\t56\tDEF\t2.7183\t2014-01-02"  "F\t\t\t0\t"                     
## [5] "B\t35\tXYZ\t3.1416\t2014-01-05"
```


*writeLines* can write these convered lines to a tab-separated-value (TSV) file:


```r
writeLines(data.lines.tab, "Sample.tsv")
```

       
Note:  Tab-delimited data are often written to .txt or .tab files, too. 

**Caution**:  Tabs provide ambiguous white space in different editors and editing them can be tricky.   

The **gedit** editor only hints the file contains tabs by the left justification of columns, but the file could have spaces or tabs.  Visual inspection does not identify whether a file has tabs or spaces or a mixture:

![gedit display of Sample.tsv](Sample-TSV-Gedit.jpg)

An ancient **kedit** editor can be configured to show tabs (and other special characters) as filled circles making it safe to edit the tabs:

![kedit display of Sample.tsv](Sample-TSV-Kedit.jpg)

       
2. Verify data correctly written
--------------------------------

The data can be read using **readLines** into a new R object and compared against the original vector of character strings:

 

```r
data.lines.copy.comma <- readLines("Sample.csv")
data.lines.copy.comma
```

```
## [1] "Grade,Age,Code,Amount,Start" "A,23,ABC,48.982,2014-01-01" 
## [3] "B,56,DEF,2.7183,2014-01-02"  "F,,,0,"                     
## [5] "B,35,XYZ,3.1416,2014-01-05"
```

```r

# Compare with original
data.lines.copy.comma == data.lines.comma
```

```
## [1] TRUE TRUE TRUE TRUE TRUE
```

```r
all(data.lines.copy.comma == data.lines.comma)
```

```
## [1] TRUE
```

                                                     
Read tsv from disk to verify write was successful


```r
data.lines.copy.tab <- readLines("Sample.tsv")
data.lines.copy.tab
```

```
## [1] "Grade\tAge\tCode\tAmount\tStart" "A\t23\tABC\t48.982\t2014-01-01" 
## [3] "B\t56\tDEF\t2.7183\t2014-01-02"  "F\t\t\t0\t"                     
## [5] "B\t35\tXYZ\t3.1416\t2014-01-05"
```

```r

# Compare with original
data.lines.copy.tab == data.lines.tab
```

```
## [1] TRUE TRUE TRUE TRUE TRUE
```

```r
all(data.lines.copy.tab == data.lines.tab)
```

```
## [1] TRUE
```


3. Final readLines/writeLines example:  Save HTML from web page
---------------------------------------------------------------

Let's save a copy of [The R Journal archive](http://journal.r-project.org/archive/) page for future comparison to detect what changes have been made.


```r
s <- readLines("http://journal.r-project.org/archive/")
length(s)
```

```
## [1] 256
```

```r
head(s)
```

```
## [1] "<!DOCTYPE html>"                                                      
## [2] ""                                                                     
## [3] "<html>"                                                               
## [4] "<head>"                                                               
## [5] "  <title>Past issues. The R Journal</title>"                          
## [6] "  <link rel=\"stylesheet\" type=\"text/css\" href=\"/r-journal.css\">"
```

```r
tail(s)
```

```
## [1] ""                                                 
## [2] "  ga('create', 'UA-40966673-1', 'r-project.org');"
## [3] "  ga('send', 'pageview');"                        
## [4] "</script>"                                        
## [5] "</body>"                                          
## [6] "</html>"
```

```r

tail(head(s, 65), 1)  # Current issue (for now)
```

```
## [1] "  <li><a href=\"2013-2/\">2013. Issue 2, Dec</a></li> "
```

```r

# Save copy locally to look for differences in future
timestamp <- format(Sys.time(), "%Y-%m-%d-%H%M%S")
filename <- paste0("R-Journal-Archive-page-", timestamp, ".html")
filename
```

```
## [1] "R-Journal-Archive-page-2014-01-14-231507.html"
```

```r
writeLines(s, filename)
```

