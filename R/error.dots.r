#adapted (taken) from dotchart with some minor addition of confidence intervals and to interface with statsBy, describeBy and cohen.d
  
#July 17, 2016
#input is the mean + standard errors, and (optionally, alpha)
#August 12, added the ability to find (and save) the stats using describe or describeBy
#Modified Oct, 4, 2019 to include cohen.d values
#corrected April 27, 2022 to correctly call Item in dictionary
"error.dots" <- 
function (x=NULL,var=NULL, se=NULL, group=NULL,sd=FALSE, effect=NULL,
 stats=NULL, head = 12, tail = 12, sort=TRUE,decreasing=TRUE,main=NULL,
 alpha=.05,eyes=FALSE, min.n = NULL,max.labels =40, labels = NULL,
  label.width=NULL, select=NULL, 
   groups = NULL, gdata = NULL, cex = par("cex"), 
    pt.cex = cex, pch = 21, gpch = 21, 
    bg = par("bg"), fg=par("fg"), color = par("fg"), 
    gcolor = par("fg"), lcolor = "gray", 
    xlab = NULL, ylab = NULL,xlim=NULL,add=FALSE,order=NULL, ...) 
{
    opar <- par("mai", "mar", "cex", "yaxs")
    on.exit(par(opar))
    par(cex = cex, yaxs = "i")
    #first, see if the data come from a psych object with sd and n or se 
    
     if(length(class(x)) > 1)  {
     cohen.d <- fa.ci <- NULL  #strange fix to R compiler
    names <- cs(statsBy,describe,describeBy, fa.ci,bestScales,cohen.d)
    value <- inherits(x,names,which=TRUE)  # value <- class(x)[2]
    if(any(value > 1) ) { obj <- names[which(value > 0)]} else {obj <- "other"}
    
    } else {obj <- "other"}
  #  if(length(class(x)) > 1 ) {if (class(x)[1] == "psych") {obj <- class(x)[2]
    des <- NULL
    switch(obj,
        statsBy = {if(is.null(min.n))  {  if(!is.null(effect)) {   #convert means to effect sizes compared to a particular group
                                   x$mean[,var]  <- ( x$mean[,var]  -x$mean[effect,var])/x$sd[effect,var]                         
                     } 
                     se <- x$sd[,var]/sqrt(x$n[,var]) 
                   x <- x$mean[,var]
                  
                                              } else {se <- x$sd[,var]
                                             n.obs <- x$n[,var]
                                              x <- x$mean[,var]
                                              if(!is.null(effect)) {   #convert means to effect sizes compared to a particular group
                                              x <- ( x$mean[,var]  -x$mean[effect,var])/x$sd[effect,var]
                                            
                                              }
                                              if(sd) {se <- x$sd[,var] } else {se <- se/sqrt(n.obs)}
                                              x <- subset(x,n.obs > min.n)
                                              se <- subset(se,n.obs > min.n)
                                              n.obs <- subset(n.obs, n.obs > min.n)
                                             
                                              }},
     describe = {if(sd) {se <- x$sd} else {se <- x$se}
        			if(is.null(labels)) labels <- rownames(x)
                    x <- x$mean
                    names(x) <- labels
                    },
     describeBy = {des <- x
         if(is.null(xlab)) xlab <- var 
         var <- which(rownames(des[[1]]) == var) 
         x <- se <-  rep(NA,length(des))
         for(grp in 1:length(x)) {
          x[grp] <- des[[grp]][["mean"]][var]
          if(sd) {se[grp] <- des[[grp]][["sd"]][var]} else {se[grp] <- des[[grp]][["se"]][var]}
                   }
         names(x) <- names(des)
          if(is.null(xlab)) xlab <- var 
        }, 
     fa.ci ={se = x$cis$sds
              if(is.null(labels)) labels <-rownames(x$cis$means) 
              x <-x$cis$means },
     bestScales = {se <- x$stats$se
         	          rn <- rownames(x$stats)
                      x <- x$stats$mean
                      names(x) <-rn
                      des <- NULL},
    cohen.d = {des <- x$cohen.d[,"effect"]
             se <- x$se
             
             if(!is.null(x$dict)) {
             cn <- colnames(x$dict)[which(colnames(x$dict) %in% c("Content","Items","content","item","Item"))]
            # names <- x$dict %in% c("Content","Items","content","item","Items")
             names <- x$dict[,cn]
            # names <- x$dict[,"Content"]
             } else {names <- rownames(x$cohen.d)}
                x <- des
                names(x) <- names
                sd <- TRUE #use these values for the confidence intervals
         },
         
  reliability ={ x <- x$splits
         if (sort) { if(is.null(order)) {ord <- order(x,decreasing=!decreasing) } else {ord<- order}
    }  else {ord <- n.var:1}  
 
   
    		 x <- x[ord]
              names <- rownames(x)
              se <- NULL
             
             },
             
  other = {}   #an empty operator 
        )#end switch
      if (obj=="other"){

      if(is.null(group)) {  #the case of just one observation per condition
      	if(is.null(stats)) {
     		 if(is.null(dim(x))) {se <- rep(0,length(x))
         des <- x
         labels=NULL } else {
       des <-   describe(x)
         x <-des$mean
        if(sd) { se <- des$sd} else {se <- des$se}
         names(x) <- rownames(des)}
          }  else { #the normal case is to find the means and se
          x <- stats$mean
          se <- stats$se 
          names(x) <- rownames(stats)
          des <- NULL
        }
          } else {
          if(is.null(xlab)) xlab <- var 
         des <- describeBy(x,group=group)
         x <- se <-  rep(NA,length(des))
         names(x) <- names(des)
         var <- which(rownames(des[[1]]) == var)
        
       
        for(grp in 1:length(des)) {
          x[grp] <- des[[grp]][["mean"]][var]
         if(sd) { se[grp] <- des[[grp]][["sd"]][var]} else {se[grp] <- des[[grp]][["se"]][var]}
          
          }}
       } 
     n.var <- length(x)
   # if(!is.null(se) && !sd) {ci <- qnorm((1-alpha/2))*se} else {ci <- NULL}
    if (sort) { if(is.null(order)) {ord <- order(x,decreasing=!decreasing) } else {ord<- order}
    }  else {ord <- n.var:1}   
    		 x <- x[ord]
   		    se <- se[ord]
   		 
   	 
   	
   	temp <- temp.se <- rep(NA,min(head+tail,n.var))
   	if((head+tail) < n.var) {
   	if (head > 0 ){ temp[1:head] <- x[1:head]
   	                temp.se[1:head] <- se[1:head]
   	                names(temp) <- names(x)[1:head]
   	                }
   	if(tail > 0 ) {temp[(head + 1):(head + tail)] <- x[(length(x)-tail+1):length(x)]
   	               temp.se[(head + 1):(head + tail)] <- se[(length(x)-tail+1):length(x)] 
   	                names(temp)[(head + 1):(head + tail)] <- names(x)[(length(x)-tail+1):length(x)]
   	               }
   	   
   	 x <- temp
   	 se <- temp.se
   	  }
   	 
   	 
 
   	 if(missing(main)) {if(sd) {main <- "means + standard deviation"} else {main="Confidence Intervals around the mean"}}
   	  

   	if(is.null(labels))  labels <- names(x)
   	 if(sd) {ci <- se} else {ci <- qnorm((1-alpha/2))*se}
   #	 if(!is.null(se)) {ci <- qnorm((1-alpha/2))*se} else {ci <- NULL}
   	  if(!is.null(ci) && is.null(xlim)) xlim <- c(min(x - ci,na.rm=TRUE),max(x + ci,na.rm=TRUE)) 
           
   	 labels <- substr(labels,1,max.labels)
   	 
   	   if(eyes) {  #get ready to draw catseyes
    	     ln <- seq(-3,3,.1)
    	     rev <- (length(ln):1)
    	     }
   	
   	        if (!is.numeric(x)) 
        stop("'x' must be a numeric vector or matrix")
    n <- length(x)
    if (is.matrix(x)) {
        if (is.null(labels)) 
            labels <- rownames(x)
        if (is.null(labels)) 
            labels <- as.character(1L:nrow(x))
        labels <- rep_len(labels, n)
        if (is.null(groups)) 
            groups <- col(x, as.factor = TRUE)
        glabels <- levels(groups)
    }
    else {
        if (is.null(labels)) 
            labels <- names(x)
        glabels <- if (!is.null(groups)) 
            levels(groups)
        if (!is.vector(x)) {
            warning("'x' is neither a vector nor a matrix: using as.numeric(x)")
            x <- as.numeric(x)
        }
    }
   if(!add) plot.new()
    linch <- if (!is.null(labels)) 
        max(strwidth(labels, "inch"),label.width, na.rm = TRUE)
    else 0
    if (is.null(glabels)) {
        ginch <- 0
        goffset <- 0
    }
    else {
        ginch <- max(strwidth(glabels, "inch"),label.width, na.rm = TRUE)
        goffset <- 0.4
    }
    if (!(is.null(labels) && is.null(glabels))) {
        nmai <- par("mai")
        nmai[2L] <- nmai[4L] + max(linch + goffset, ginch) + 
            0.1
        par(mai = nmai)
    }
    if (is.null(groups)) {
        o <- 1L:n
       if(!is.null(select))  o <- o[select]
       y <- o 
       x <- x[o]
       if(!is.null(ci)) ci <- ci[o]
        ylim <- c(0, n + 1)
    }
    else {
        o <- sort.list(as.numeric(groups), decreasing = TRUE)
        x <- x[o]
        groups <- groups[o]
        color <- rep_len(color, length(groups))[o]
        lcolor <- rep_len(lcolor, length(groups))[o]
        offset <- cumsum(c(0, diff(as.numeric(groups)) != 0))
        y <- 1L:n + 2 * offset
        ylim <- range(0, y + 2)
    }
    plot.window(xlim = xlim, ylim = ylim, log = "")
    lheight <- par("csi") 
    if (!is.null(labels)) {
        linch <- max(strwidth(labels, "inch"), na.rm = TRUE)
        loffset <- (linch + 0.1)/lheight
        labs <- labels[o]
       mtext(labs, side = 2, line = loffset, at = y, adj = 0, 
            col = color, las = 2, cex = cex, ...)
    }
    abline(h = y, lty = "dotted", col = lcolor)
    points(x, y, pch = pch, col = color, bg = bg, cex = pt.cex/cex)
    if(!is.null(ci)) {if(!eyes) {
    segments(x - ci, y, x+ci, y,bg=bg,col=fg,...)
 #        col = par("fg"), lty = par("lty"), lwd = par("lwd"))
         } }
    if (!is.null(groups)) {
        gpos <- rev(cumsum(rev(tapply(groups, groups, length)) + 
            2) - 1)
        ginch <- max(strwidth(glabels, "inch"), na.rm = TRUE)
        goffset <- (max(linch + 0.2, ginch, na.rm = TRUE) + 0.1)/lheight
        mtext(glabels, side = 2, line = goffset, at = gpos, adj = 0, 
            col = gcolor, las = 2, cex = cex, ...)
        if (!is.null(gdata)) {
            abline(h = gpos, lty = "dotted")
            points(gdata, gpos, pch = gpch, col = gcolor, bg = bg, 
                cex = pt.cex/cex, ...)
        }
    }
   if(eyes) {
   for (e in 1:(min(head+tail,n.var))) {catseye(x[e],y[e],ci[e]/qnorm(1-alpha/2),alpha=alpha,density=density) }}
  if(!add)  axis(1)
  if(!add)  box()
    title(main = main, xlab = xlab, ylab = ylab, ...)
   
    
   result <- list(des =des,order=ord)
     invisible(result)
    #report the order if sort 
}



  
#modified from catseyes in error.bars
  "catseye" <- function(x,y,ci,alpha,density=density,col=col) {
     SCALE=.7
    	     ln <- seq(-3,3,.1)
    	     rev <- (length(ln):1)
     norm <- dnorm(ln) 
    # clim <- qnorm(alpha/2)
    #norm <-  dt(ln,n-1) 
    clim <- qnorm(alpha/2)
    #clim <- ci
    norm <- c(norm,-norm[rev])
    ln <- seq(-3,3,.1)
    cln <- seq(clim,-clim,.1)
    cnorm <- dnorm(cln)
    cnorm <- c(0,cnorm,0,-cnorm,0)  #this closes the probability interval	  
   # polygon(norm*SCALE*ci+x,c(ln,ln[rev])+y)
    polygon(c(ln,ln[rev])*ci+x, norm*SCALE+y)
   # polygon(cnorm*SCALE+x,c(clim,cln,-clim,-cln,clim)*ci+y,density=density,col=col)
   }
    
   	