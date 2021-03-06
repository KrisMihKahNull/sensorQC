#'@export
plot_summary <- function(inst.data, inst.flags, block.data = NULL, block.flags = NULL, compare.data = NULL, sqc){
  panels = rep(1,40) # init as full plot
  panels = append(panels,c(3,3,3))
  
  if (is.null(block.data)){
    tot.flag <- ncol(inst.flags)# currently, block flags are 1D
  } else {
    tot.flag <- ncol(inst.flags)+ncol(block.flags)
    flat.block <- flatten_flags(block.flags)
  }
  
  panels[1:tot.flag] = 2
  
  
  
  xlm = c(min(inst.data[, 1]), max(inst.data[, 1]))
  ylm = c(0,1)
  if (!is.null(block.data)){
    ylm[2]= 1.1*max(block.data[, 2])
  } else {
    ylm[2]= 1.1*max(inst.data[!flatten_flags(inst.flags), 2])
  }
  
  
  
  layout(panels)
  par(mai=c(0,1.5,.1, .5),omi=c(0,0,0,0))
  plot(inst.data[, 1],rep(NA,nrow(inst.data)),ylim=ylm,
       ylab="SUNA nitrate concentration (micromoles)",
       xlab="",xaxs="i")
  
 
  if (!is.null(compare.data)){
    lines(compare.data[,1:2],lty=6,col=rgb(1, 0, 0, .6, maxColorValue = 1),lwd=1)
    
  }
  
  if (!is.null(block.data)){
    points(inst.data[, 1:2],col="green",pch=19,cex=0.4)
    points(block.data[!flat.block, 1:2],lty=1,lwd=4,pch=19,cex=0.8)
  } else {
    points(inst.data[!flatten_flags(inst.flags), 1:2],col="green",pch=19,cex=0.4)
    points(inst.data[flatten_flags(inst.flags), 1:2],col="red",pch=4,cex=0.4,lwd = 1)
  }
  
  plot(c(1,NA),c(NA,0),ylim = c(tot.flag,0),xlim = xlm,xlab=NA,ylab=NA,axes=F,
       xaxs="i", yaxs="i")
  
  
  ynames <- c(NA)
  for (i in 1:ncol(inst.flags)){
    flags <- inst.flags[, i]
    use.i <- flags[!is.na(flags)]
    if (!is.null(block.data)){
      points(inst.data[use.i,1],rep(i-.5,length(use.i)),pch=15,cex=2.5,
             col=rgb(0, 0, 0, .2, maxColorValue = 1))
    } else {
      points(inst.data[use.i,1],rep(i-.5,sum(use.i)),pch=15,cex=2.5,
             col=rgb(0, 0, 0, .2, maxColorValue = 1))
    }
    
    abline(h = i)
    nme <- sqc$outlier_removal[[i]]$alias
    ynames <- c(ynames,nme)
  }
  ix = i
  
  if (!is.null(block.data)){
    for (k in 1:ncol(block.flags)){
      ix=1+ix
      flags <- block.flags[, k]
      points(block.data[flags,1],rep(ix-.5,sum(flags)),pch=15,cex=2.5,
             col=rgb(1, 0, 0, .4, maxColorValue = 1))
      abline(h = ix)
      nme <- sqc$block_stats[[k]]$alias
      ynames <- c(ynames,nme)
    }
  }
  
  
  ynames <- c(ynames,NA)
  par(mgp=c(1.8,.5,0))
  axis(1,at=c(xlm[1]-1,xlm[2]+1),las=1, tck=0.0001,labels=NA,lwd=2)
  axis(2,at=seq(-.5,tot.flag+1, 1),las=1, tck=0.0001,labels=ynames,lwd=2)
  axis(4,at=seq(-.5,tot.flag+1, 1),las=1, tck=0.0001,labels=NA,lwd=2)
  axis(3,at=c(xlm[1]-100,xlm[2]+100),las=1, tck=0.0001,labels=NA,lwd=2)
  
}