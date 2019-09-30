%% simulate stage 1 model free
% KLI 20190927
%
% alpha = 1, beta=2, p=0.1 gets nice bar plots
%%

totalTrials=201;
alpha=0.5;
beta=2;
p=0.1;

reward_prob1=0.5;
reward_prob2=0.5;

%%
commonProb=0.7;
minSet=20;
transitionMat=generateTransitions(totalTrials,commonProb,minSet);

Qmf=zeros(1,2);
Qs2=zeros(1,2);

dataSheet=zeros([totalTrials-1,13]);

trial=1;

countS1_1=1; % used to keep track of which choice was made
countS1_2=1;
count1=1;
count2=2;

s1Choice=randi(2,1);
prevChoice=1;

while trial < totalTrials
   
    % determine s2 based on whether it is a common or rare transition
    if s1Choice == 1
        transition=transitionMat(count1,1);
        
        if transition == 1 % then its common
            s2=1;
        elseif transition == 0
            s2=2;
        end
        
        countS1_1=countS1_1+1;
    else
        transition=transitionMat(count2,2);
        
        if transition == 1
            s2=2;
        elseif transition == 0
            s2=1;
        end
        
        countS1_2=countS1_2+2;
    end
    
    %%
    
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
        
    Qs2(s2)=Qs2(s2)+(alpha*(reward-Qs2(s2)));
    Qs2(3-s2)=Qs2(3-s2)*(1-alpha);
    
    Qmf(s1Choice)=Qmf(s1Choice)+(alpha*(Qs2(s2)-Qmf(s1Choice)));
    Qmf(3-s1Choice)=Qmf(3-s1Choice)*(1-alpha);
    
    
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
    dataSheet(trial,9)=reward;
    dataSheet(trial,10)=Qmf(1);
    dataSheet(trial,11)=Qmf(2);
    dataSheet(trial,12)=s1Choice;
    dataSheet(trial,13)=transition;
    
    
    %% calc s1 Choice for next trial
    
    softmax1=exp(beta*Qmf(1))/(exp(beta*Qmf(1))+exp(beta*Qmf(2)));
    softmax2=exp(beta*Qmf(2))/(exp(beta*Qmf(1))+exp(beta*Qmf(2)));

%     softmax1=1/(1+exp(-beta*(Qmf(1)-Qmf(2))));
%     softmax2=1/(1+exp(-beta*(Qmf(2)-Qmf(1))));

    if prevChoice==s1Choice
        rep_a=1;
    else
        rep_a=0;
    end
% 
%     softmax1=exp(beta*(Qmf(1)+p*rep_a))/(exp(beta*(Qmf(1)+p*rep_a))+exp(beta*(Qmf(2)+p*rep_a)));
%     softmax2=exp(beta*(Qmf(2)+p*rep_a))/(exp(beta*(Qmf(1)+p*rep_a))+exp(beta*(Qmf(2)+p*rep_a)));
% 
%     
    prevChoice=s1Choice;
    
    
    if ( softmax1 == softmax2 )
        randnum = rand;
        if ( randnum <=0.5 )
            s1Choice = 1;
        else
            s1Choice = 2;
        end
    else
        randnum = rand;
        if ( randnum < softmax1 )
            s1Choice = 1;
        else
            s1Choice = 2;
        end
    end
    
    dataSheet(trial,14)=softmax1;
    dataSheet(trial,15)=softmax2;
%     %%
%     disp('transition');
%     disp(transition);
%     disp('reward');
%     disp(reward);
    
    trial=trial+1;
    
end

% 
% plot(dataSheet(:,1),dataSheet(:,10),...
%     dataSheet(:,1),dataSheet(:,14),...
%     dataSheet(:,1),dataSheet(:,11),...
%     dataSheet(:,1),dataSheet(:,15))
% legend('Qmf(1)','softmax1','Qmf(2)','softmax2','FontSize',14)
% 
% figure
% plot(dataSheet(:,1),dataSheet(:,10),...
%     dataSheet(:,1),dataSheet(:,14))
% legend('Qmf(1)','softmax1','FontSize',14)
% 
% 
% figure
% plot(dataSheet(:,1),dataSheet(:,11),...
%     dataSheet(:,1),dataSheet(:,15))
% legend('Qmf(2)','softmax2','FontSize',14)