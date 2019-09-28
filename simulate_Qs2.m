%% single stage 2 model free calculation
% KLI 20190927
%
% this is calculating model free Q (or v) for stage two, which has no action.
% Qmf(s2)=Qmb(s2)
% Qmf(s2) should be roughly the average of rewards for the s2 seen
%
%%

clear;

totalTrials=201;
alpha=0.1;

reward_prob1=0.2;
reward_prob2=0.9;

%%

Qs2=zeros(1,2);

dataSheet=zeros([totalTrials-1,5]);
trial=1;
count1=1; % here, count1 and count2 are used to keep track of total s2 seen
count2=1;

while trial < totalTrials
    
    % here, s2 is just a random choice between the two stage possibilities.
    s2=randi(2,1);
    
    %% reward
    
    winRand=rand;
    
    if s2==1
        reward_prob=reward_prob1;
    else
        reward_prob=reward_prob2;
    end
    
    
    if winRand < reward_prob
        reward=1;
    else 
        reward=0;
    end
    
    %%
    
    Qs2(s2)=Qs2(s2)+(alpha* (reward-Qs2(s2)));
    
    %% saving data
    dataSheet(trial,1)=trial;
    dataSheet(trial,2)=s2;
    
    if s2==1 % document reward for s2(1)
        count1=count1+1;
        dataSheet(trial,3)=reward;
        dataSheet(trial,4)=0;
    else % document reward for s2(2)
        count2=count2+1;
        dataSheet(trial,4)=reward;
        dataSheet(trial,3)=0;
    end
    
    dataSheet(trial,5)=Qs2(1);
    dataSheet(trial,6)=sum(dataSheet(:,3))/(count1-1); %running average of reward for s1
    dataSheet(trial,7)=Qs2(2);
    dataSheet(trial,8)=sum(dataSheet(:,4))/(count2-1); %running average of reward for s2
    %%
    
    trial=trial+1;
    
end

figure
plot(dataSheet(:,1),dataSheet(:,5),dataSheet(:,1),dataSheet(:,6),...
    dataSheet(:,1),dataSheet(:,7),dataSheet(:,1),dataSheet(:,8));
title('Qs2 simulation','FontSize',14)
legend('Qs2(1)','s1 avg reward','Qs2(2)','s2 avg reward','FontSize',14);
