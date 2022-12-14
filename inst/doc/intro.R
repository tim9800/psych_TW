### R code from vignette source 'intro.Rnw'

###################################################
### code chunk number 1: intro.Rnw:481-482
###################################################
    options(width=100)


###################################################
### code chunk number 2: intro.Rnw:486-490
###################################################
library(psych)   #need to make psych active the first time you call it
library(psychTools)  #additional tools and data are here
data(sat.act) 
describe(sat.act)  #basic descriptive statistics


###################################################
### code chunk number 3: intro.Rnw:497-499
###################################################
 #basic descriptive statistics by a grouping variable.
describeBy(sat.act ~ gender,skew=FALSE,ranges=FALSE)


###################################################
### code chunk number 4: intro.Rnw:507-510
###################################################
sa.mat <-  describeBy(sat.act ~ gender + education,
 skew=FALSE,ranges=FALSE,mat=TRUE)
headTail(sa.mat)


###################################################
### code chunk number 5: outlier
###################################################
png( 'outlier.png' )
d2 <- outlier(sat.act,cex=.8)
dev.off()


###################################################
### code chunk number 6: intro.Rnw:541-545
###################################################
x <- matrix(1:120,ncol=10,byrow=TRUE)
colnames(x) <- paste('V',1:10,sep='')
new.x <- scrub(x,3:5,min=c(30,40,50),max=70,isvalue=45,newvalue=NA)
new.x


###################################################
### code chunk number 7: pairspanels
###################################################
png( 'pairspanels.png' )
sat.d2 <- data.frame(sat.act,d2) #combine the d2 statistics from before with the sat.act data.frame
pairs.panels(sat.d2,bg=c("yellow","blue")[(d2 > 25)+1],pch=21,stars=TRUE)
dev.off()


###################################################
### code chunk number 8: affect
###################################################
png('affect.png')
pairs.panels(affect[14:17],bg=c("red","black","white","blue")[affect$Film],pch=21,
     main="Affect varies by movies ")
dev.off()


###################################################
### code chunk number 9: affect1
###################################################
keys <- list(
EA = c("active", "energetic", "vigorous", "wakeful", "wide.awake", "full.of.pep",
       "lively", "-sleepy", "-tired", "-drowsy"),
 TA =c("intense", "jittery", "fearful", "tense", "clutched.up", "-quiet", "-still", 
       "-placid", "-calm", "-at.rest") ,
PA =c("active", "excited", "strong", "inspired", "determined", "attentive", 
          "interested", "enthusiastic", "proud", "alert"),
NAf =c("jittery", "nervous", "scared", "afraid", "guilty", "ashamed", "distressed",  
         "upset", "hostile", "irritable" )) 
scores <- scoreItems(keys,psychTools::msq[,1:75])
#png('msq.png')
# pairs.panels(scores$scores,smoother=TRUE,
#  main ="Density distributions of four measures of affect" )

#dev.off()


###################################################
### code chunk number 10: violin
###################################################
png('violin.png')
data(sat.act)
violinBy(SATV+SATQ ~ gender, data=sat.act,grp.name=cs(Verbal.M,Verbal.F, Quan.M,Quant.F),  main="Density Plot by gender for SAT V and Q")
dev.off()


###################################################
### code chunk number 11: intro.Rnw:675-677
###################################################
data(epi.bfi)
error.bars.by(epi.bfi[,6:10],epi.bfi$epilie<4)


###################################################
### code chunk number 12: intro.Rnw:690-692
###################################################
error.bars.by(sat.act[5:6],sat.act$gender,bars=TRUE,
        labels=c("Male","Female"),ylab="SAT score",xlab="")


###################################################
### code chunk number 13: intro.Rnw:706-710
###################################################
T <- with(sat.act,table(gender,education))
rownames(T) <- c("M","F")
error.bars.tab(T,way="both",ylab="Proportion of Education Level",xlab="Level of Education",
main="Proportion of sample by education level")


###################################################
### code chunk number 14: intro.Rnw:729-739
###################################################
op <- par(mfrow=c(1,2))
  data(affect)
colors <- c("black","red","white","blue")
 films <- c("Sad","Horror","Neutral","Happy")
affect.stats <- errorCircles("EA2","TA2",data=affect[-c(1,20)],group="Film",labels=films,
xlab="Energetic Arousal",   ylab="Tense Arousal",ylim=c(10,22),xlim=c(8,20),pch=16,
cex=2,colors=colors, main =' Movies effect on arousal')
 errorCircles("PA2","NA2",data=affect.stats,labels=films,xlab="Positive Affect",
  ylab="Negative Affect", pch=16,cex=2,colors=colors,  main ="Movies effect on affect")
op <- par(mfrow=c(1,1))


###################################################
### code chunk number 15: bibars
###################################################
png( 'bibars.png' )
bi.bars(bfi,"age","gender",ylab="Age",main="Age by males and females")
dev.off()


###################################################
### code chunk number 16: histo
###################################################
png('histo.png')
data(sat.act)
densityBy(bfi,"age",grp="gender")
dev.off()


###################################################
### code chunk number 17: scatterhist
###################################################
png( 'scatterHist.png' )
psych::scatterHist(F ~ M + gender, data=GERAS.scales, cex.point=.3,smooth=FALSE, 
xlab="Masculine Scale",ylab="Feminine Scale",correl=FALSE, 
d.arrow=TRUE,col=c("red","blue"), bg=c("red","blue"), lwd=4, title="Combined  M and F 
scales",cex.cor=2,cex.arrow=1.25)
dev.off()


###################################################
### code chunk number 18: intro.Rnw:814-815
###################################################
lowerCor(sat.act)


###################################################
### code chunk number 19: intro.Rnw:822-828
###################################################
female <- subset(sat.act,sat.act$gender==2)
 male <- subset(sat.act,sat.act$gender==1)
lower <- lowerCor(male[-1])
upper <- lowerCor(female[-1])
both <- lowerUpper(lower,upper)
round(both,2)


###################################################
### code chunk number 20: intro.Rnw:834-836
###################################################
diffs <-  lowerUpper(lower,upper,diff=TRUE)
round(diffs,2)


###################################################
### code chunk number 21: corplot.png
###################################################
png('corplot.png')
corPlot(Thurstone,numbers=TRUE,upper=FALSE,diag=FALSE,main="9 cognitive variables from Thurstone")
dev.off()


###################################################
### code chunk number 22: circplot.png
###################################################
png('circplot.png')
circ <- sim.circ(24)
r.circ <- cor(circ)
corPlot(r.circ,main='24 variables in a circumplex')
dev.off()


###################################################
### code chunk number 23: spider.png
###################################################
png('spider.png')
op<- par(mfrow=c(2,2))
spider(y=c(1,6,12,18),x=1:24,data=r.circ,fill=TRUE,main="Spider plot of 24 circumplex variables")
op <- par(mfrow=c(1,1))
dev.off()


###################################################
### code chunk number 24: intro.Rnw:903-904
###################################################
corr.test(sat.act)


###################################################
### code chunk number 25: intro.Rnw:915-916
###################################################
r.test(50,.3)


###################################################
### code chunk number 26: intro.Rnw:922-923
###################################################
r.test(30,.4,.6)


###################################################
### code chunk number 27: intro.Rnw:930-931
###################################################
r.test(103,.4,.5,.1)


###################################################
### code chunk number 28: intro.Rnw:937-938
###################################################
r.test(103,.5,.6,.7,.5,.5,.8)  #steiger Case B 


###################################################
### code chunk number 29: intro.Rnw:946-947
###################################################
cortest(sat.act)


###################################################
### code chunk number 30: intro.Rnw:961-962
###################################################
draw.tetra()


###################################################
### code chunk number 31: intro.Rnw:1033-1034
###################################################
setCor(y = 5:9,x=1:4,data=Thurstone)


###################################################
### code chunk number 32: intro.Rnw:1041-1043
###################################################
sc <- setCor(y = 5:9,x=3:4,data=Thurstone,z=1:2)
round(sc$residual,2)


###################################################
### code chunk number 33: intro.Rnw:1056-1070
###################################################
#data from Preacher and Hayes (2004)
sobel <- structure(list(SATIS = c(-0.59, 1.3, 0.02, 0.01, 0.79, -0.35, 
-0.03, 1.75, -0.8, -1.2, -1.27, 0.7, -1.59, 0.68, -0.39, 1.33, 
-1.59, 1.34, 0.1, 0.05, 0.66, 0.56, 0.85, 0.88, 0.14, -0.72, 
0.84, -1.13, -0.13, 0.2), THERAPY = structure(c(0, 1, 1, 0, 1, 
1, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 
1, 1, 1, 0), value.labels = structure(c(1, 0), .Names = c("cognitive", 
"standard"))), ATTRIB = c(-1.17, 0.04, 0.58, -0.23, 0.62, -0.26, 
-0.28, 0.52, 0.34, -0.09, -1.09, 1.05, -1.84, -0.95, 0.15, 0.07, 
-0.1, 2.35, 0.75, 0.49, 0.67, 1.21, 0.31, 1.97, -0.94, 0.11, 
-0.54, -0.23, 0.05, -1.07)), .Names = c("SATIS", "THERAPY", "ATTRIB"
), row.names = c(NA, -30L), class = "data.frame", variable.labels = structure(c("Satisfaction", 
"Therapy", "Attributional Positivity"), .Names = c("SATIS", "THERAPY", 
"ATTRIB")))


###################################################
### code chunk number 34: intro.Rnw:1072-1073
###################################################
preacher <- mediate(SATIS ~ THERAPY + (ATTRIB),data=sobel)  #The example in Preacher and Hayes


###################################################
### code chunk number 35: intro.Rnw:1080-1081
###################################################
mediate.diagram(preacher)


###################################################
### code chunk number 36: intro.Rnw:1092-1094
###################################################
preacher <- setCor(SATIS ~ THERAPY + ATTRIB,data =sobel,std=FALSE)
setCor.diagram(preacher)


###################################################
### code chunk number 37: intro.Rnw:1136-1138
###################################################
mediate(respappr ~ prot2 * sexism +(sexism),data=Garcia,n.iter=50
  ,main="Moderated mediation (mean centered)")


###################################################
### code chunk number 38: intro.Rnw:1162-1166
###################################################

C <- cov(sat.act,use="pairwise")
model1 <- lm(ACT~ gender + education + age, data=sat.act)
summary(model1)


###################################################
### code chunk number 39: intro.Rnw:1169-1171
###################################################
#compare with sector
setCor(c(4:6),c(1:3),C, n.obs=700)


###################################################
### code chunk number 40: intro.Rnw:1292-1293
###################################################
sessionInfo()


