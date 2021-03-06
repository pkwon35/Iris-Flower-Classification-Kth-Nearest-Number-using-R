---
  title: "IRIS FLOWER CLASSIFICATION (R)"
output: html_document
---
  

#Skills Acquired from Following Coding:
#(1) Separating Testing and Training set
#(2) Using Cross Validation to find best K for KNN()


## (1) Install Packages (Only do this if never installed)

# data.table --> fast aggregation of large data, fast ordered joins, modify columns
#install.packages("data.table")

# gglot2 --> plotting system for R
#install.packages("ggplot2")

# ggfortify --> Data Visualization tool for statistical analysis result
#install.packages("ggfortify")

# caret --> classification and regression training
# install.packages("caret"", dependencies = TRUE)

# class --> classification (k-nearest neighbour, learning vector quantization)
# need this package for kth-nearest neighboring classification
#install.packages("class")

# gridExtra --> functions for grid graphics
#install.packages("gridExtra")

# GGally --> extends 'ggplot2' by adding several functions
#install.packages("GGally")

# Rgraphics --> data and functions from the book R Graphics
#install.packages("RGraphics")

# gmodels --> programming tools for model fitting
#install.packages("gmodels")

# plotly --> create interactive charts and dashboards
# install.packages("plotly")


## (2) Load Packages


library("data.table")
library("ggplot2")
library("ggfortify")
library("caret")
library("class")
library("gridExtra")
library("GGally")
library("RGraphics")
library("gmodels")
library("plotly")


## (3) Load iris dataset
# Download iris data from the following link
# https://archive.ics.uci.edu/ml/machine-learning-databases/iris/
#  download iris.data file



# attach(iris)
# data(iris)
# head(iris)


# exploratory analysis
# summary(iris)


## (4) Exploratory Analysis
# Using following code will graph flowers on the data based on

# y axis = sepal length

# x axis = sepal width

# Different color shapes represent different species.


gg1<-ggplot(iris,aes(x=Sepal.Width,y=Sepal.Length, 
                     shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) +
  geom_point(size=2) + 
  labs(title = "Sepal Width Vs. Sepal Length")

ggplotly(gg1)


# Next plot has following axis

# y axis = petal length

# x axis = pepal width



# I have changed colour for axis to help you analyze the code

gg2<-ggplot(iris,aes(x=Petal.Width,y=Petal.Length, 
                     shape=Species, color=Species)) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="red"),
        axis.line.x = element_line(colour="blue"),
        axis.line.y = element_line(colour="yellow")) +
  geom_point(size=2) + 
  labs(title = "Sepal Width Vs. Sepal Length")

ggplotly(gg2)



# Create Plot that shows the relationhips across various explanatory variables 

# (Shows plots for every possible pairs of following 4 variables)

# 1) petal.length
# 2) petal.width
# 3) sepal.length
# 4) sepal.width


pairs <- ggpairs(iris,mapping=aes(color=Species),columns=1:4) + 
  theme(panel.background = element_rect(fill = "gray98"),
        axis.line   = element_line(colour="black"),
        axis.line.x = element_line(colour="gray"),
        axis.line.y = element_line(colour="gray")) 
pairs

ggplotly(pairs) %>%
  layout(showlegend = FALSE)



## (5) Model Estimation
# Kth-nearest neighbor analysis:
#   Method to estimate/classify the outcome of the new point on the graph based on a selected number of its nearest neighbors.


# Calculate sample size for training set


set.seed(123)
# When creating training set, must use sample size of about 75% of available data.

samplesize <- floor(nrow(iris)*0.75)
# floor() function returns the largest integer not greater than the giving number.

samplesize


# Choose training samples randomly

# list of indices of all rows
indices <- seq_len(nrow(iris))

#create train.ind which denotes indices of rows going to be used as part of training sample 
# (it randomly chooses 112 indices out of 150 indices)

train.ind <- sample(indices, size=samplesize)
train.ind

# Using the list of 112 indices, create a list by obtaining rows of data from the indices randomly chosen.


train <- iris[train.ind, ]
head(train)


# From the training set, Select out Species

train.set <- subset(train,select=-c(Species))
head(train.set)

# Create testing set
# Using "-train.ind" calls indices that are not used in training.



test <- iris[-train.ind,]
head(test)

# select out Species from testing set
test.set <- subset(test,select=-c(Species))
head(test.set)


# Make separate set with classification of different flowers for training set

train.class<-train[,"Species"]
train.class

# Make separate set with classification of different flowers for testing set


test.class <- test[,"Species"]
test.class

# k-Nearest Neighbour classification uses following function:
  
  knn(train,test,cl,k=1,l=0,prob=FALSE, use.all=TRUE)



# train=training set

# test=testing set

# cl = classifications of training set

# k = number of neighbours considered


# It is important to find the right k, number of neighbours to consider. 


set.seed(123)

contrl <- trainControl(method="repeatedcv",repeats=3)
# Following link from youtube explains cv 
#                              (K-Fold Cross validation)
# https://www.youtube.com/watch?v=TIgfjmp-4BA

knn.K <- train(Species ~ ., data = train, 
               method = "knn", 
               trControl = contrl, 
               preProcess = c("center","scale"),
               tuneLength = 20)

knn.K


# Optimal k = 9

## (6) Prediction Results


knn.iris <- knn(train = train.set, 
                test = test.set, 
                cl = train.class, 
                k = 9, 
                prob = T)

# dim() set the dimension of an object.
# (#of rows, #of columns)
dim(train)

# (train.class) will get an error code if data frame is used
dim(train.class)


length(train.class)



# Below table shows how successful was the testing value

table(test.class,knn.iris)

# 1 virginica was misclassified as versicolor

# Calculate test error:
  

# Number of total observations = 38
# Number of incorrectly observed = 1

testerror = 1/38
testerror


# Above processes was referenced from inertia7
# https://www.inertia7.com/projects/10
