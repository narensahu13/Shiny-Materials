###########################################
#####   DAY 1 PPT SLIDES SCRIPT FOR   #####
#####        FUNDAMENTALS OF R        #####
###########################################

# to see what packages are currently 
# in your workspace
search() # displays packages and data frames

# to see what packages are 
# installed in your working directory
library()

#### TWO-STEP PROCESS TO MAKE PACKAGE ACTIVE:
## 1. INSTALL THE PACKAGE (ONLY 
# NEED DO THIS ONE TIME):
install.packages("survey")

## 2. LOAD THE PACKAGE INTO 
# YOUR WORKSPACE (DO THIS EACH TIME):
library("survey")

## Reading in Data and Importing Files
# Read in a text file from URL 
# and assign it to a variable in workspace:
d1 <- read.table("http://www.bio.ic.ac.uk/research/mjcraw/therbook/data/worms.txt",header=T)
head(d1) # to display first six records

# Read in a text file from your hard drive:
d2 <- read.table("c://temp/worms.missing.txt",header=T)
head(d2) # first six records
tail(d3) # to show last 6 records

# Read in data interactively from keyboard
# and assign data to vector 'x':
x <- scan()
x

# ls() and objects() returns 
# vector of character strings
# giving names of data sets 
# and functions a user has defined
ls()

# removes all variable and 
# function objects from workspace
rm(list=ls())

# returns an empty character string:
ls()

# print (list) the working directory
getwd()

# change the working directory
setwd(new.dir) # must include entire path

# save the workspace to the file 
# ".RData" (default)
save.image()

# which is equivalent to
save(list=ls(all=TRUE),file=".RData")

# save a specific object to a file
save(object, file="myfile.RData")

# load a saved workspace into 
# the current session
# must have entire path name
load(object, file="C:/Users/jeff/Documents/myfile.RData") 

# to install a package (libraries)
install.packages("name_of_package")

# shows you installed packages (libraries)
library()

# to load an installed package like mgcv
library(mgcv)

# list of available options, opens a web page
help(options)

# view current options settings
options()

# set number of digits to print on output
options(digits=3)

# quit R
q()

# quit without R asking you whether 
# it should save your data
q(save="no")

## HELP COMMANDS

# Help on function solve()
help(solve)

# or, for short, just:
?solve

# On most systems have help in html by
# 'Search Engine and Keywords' 
# link especially useful
help.start()

# help.search() command or alternatively 
# ?? allow searching
# in various ways
??solve
