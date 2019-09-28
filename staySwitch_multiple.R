library(dplyr)
library(ggplot2)

subjID='mf_postmod'
iters=100;
path2file='/Users/npnlusc/Documents/Projects/stroke_compensation/scripts/RL_simulations'

path2save='/Users/npnlusc/Documents/Projects/stroke_compensation/scripts/RL_simulations'

filestring=paste(path2file,subjID, sep='/')

# load in the raw csv file
df<-read.csv(paste(filestring,'.csv',sep=''), header=TRUE)
names(df)[1] <- "iteration" 
names(df)[2] <- "commonRare" 
names(df)[3] <- "choice" 
names(df)[4] <- "reward" 


shift <- function(x, n){
  c(x[-(seq(n))], rep(NA, n))
}

# determine stay or switch on each trial
# if the choice is the same as the last trial, then stay. otherwise, switch
df$choiceN <-shift(df$choice,1)

df$stay[df$choice == df$choiceN]<-1
df$stay[df$choice != df$choiceN]<-0

####
stayPerGroup<-df %>% 
  group_by(iteration,reward,commonRare) %>% 
  summarise(stay= sum(stay)) 

totalInGroup<-df %>% 
  group_by(iteration,reward,commonRare) %>% 
  tally()

merged<- merge(stayPerGroup,totalInGroup,by=c("iteration","reward","commonRare"))
merged$stayProbability<- merged$stay/merged$n 

merged$commonRare <- as.factor(merged$commonRare)
merged$commonRare<-recode(merged$commonRare, '0'="rare", '1'="common")
merged$commonRare <- factor(merged$commonRare, levels = c("common","rare"))

merged$reward <- as.factor(merged$reward)
merged$reward<-recode(merged$reward, '0'="unrewarded", '1'="rewarded")
merged$reward <- factor(merged$reward, levels = c("rewarded","unrewarded"))

results<-merged %>%
  group_by(commonRare,reward) %>%
  summarise_at(vars(stayProbability), funs(mean(., na.rm=TRUE), sd(.,na.rm=TRUE)))

results$se <- results$sd / sqrt(iters-1)

# ggplot(results, aes(factor(reward), mean, fill = commonRare)) +
#   geom_bar(stat="identity", position = "dodge") +
#   scale_fill_discrete(name = "Transition") +
#   scale_x_discrete(name ="Rewarded")+
#   scale_y_continuous(limits = c(0, 1), name="Stay Probability")+
#   geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
#                 position=position_dodge(.9)) 


ggplot(results, aes(factor(reward), mean, fill = commonRare)) +
  geom_bar(stat="identity", position = "dodge") +
  scale_fill_discrete(name = "Transition") +
  scale_x_discrete(name ="Rewarded")+
  scale_y_continuous(limits = c(0, 1), name="Stay Probability")+
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2,
                position=position_dodge(.9)) 
