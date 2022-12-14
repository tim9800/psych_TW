\name{scrub}
\alias{scrub}

\title{A utility for basic data cleaning and recoding.  Changes values outside of minimum and maximum limits to NA. }
\description{A tedious part of data analysis is addressing the problem of miscoded data that need to be converted to NA or some other value.  For a given data.frame or matrix, scrub will set all values of columns from=from to to=to that are less than a set (vector) of min values or more than a vector of max values to NA. Can also be used to do basic recoding of data for all values=isvalue to newvalue. Will also recode continuus variables into fewer categories.  Will convert Nan, -Inf and Inf to NA

The length of the where, isvalue, and newvalues must either match, or be 1.
}
\usage{
scrub(x, where, min, max,isvalue,newvalue, cuts=NULL)
}

\arguments{
  \item{x}{a data frame or matrix}
  \item{where}{The variables to examine.  (Can be by name or by column number)}
  \item{min}{a vector of minimum values that are acceptable}
  \item{max}{a vector of maximum values that are acceptable}
 \item{isvalue}{a vector of values to be converted to newvalue (one per variable)}
\item{newvalue}{a vector of values to replace those that match isvalue}
 \item{cuts}{The lower,and upper boundaries for recoding }}
 
\details{Solves a tedious problem that can be done directly but that is sometimes awkward.  Will either replace specified values with NA or will recode to values within a range.
}
\value{
The corrected data frame.}

\author{William Revelle

}

\seealso{ \code{\link{reverse.code}}, \code{\link{rescale}} for other simple utilities.
}
\examples{
data(attitude)
x <- scrub(attitude,isvalue=55) #make all occurrences of 55 NA
x1 <- scrub(attitude, where=c(4,5,6), isvalue =c(30,40,50), 
     newvalue = c(930,940,950)) #will do this for the 4th, 5th, and 6th variables
x2 <- scrub(attitude, where=c(4,4,4), isvalue =c(30,40,50), 
            newvalue = c(930,940,950)) #will just do it for the 4th column
new <- scrub(attitude,1:3,cuts= c(10,40,50,60,100))  #change many values to fewer 
#get rid of a complicated set of cases and replace with missing values
y <- scrub(attitude,where=2:4,min=c(20,30,40),max= c(120,110,100),isvalue= c(32,43,54))
y1 <- scrub(attitude,where="learning",isvalue=55,newvalue=999) #change a column by name
y2 <- scrub(attitude,where="learning",min=45,newvalue=999) #change a column by name

y3 <- scrub(attitude,where="learning",isvalue=c(45,48),
    newvalue=999) #change a column by name look for multiple values in that column
y4 <- scrub(attitude,where="learning",isvalue=c(45,48),
      newvalue= c(999,-999)) #change values in one column to one of two different things

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{multivariate }
%code is in reverse.code
