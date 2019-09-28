function data=staySwitch_Data (iterations,numTrials)
    
    data=zeros(numTrials*iterations,4);
    
    for i=1:iterations
        data(((i-1)*numTrials)+1:numTrials*i,1)=i;
        
          simulate_Qmb;
          
          data(((i-1)*numTrials)+1:numTrials*i,2)=dataSheet(:,13); % commonRare
          data(((i-1)*numTrials)+1:numTrials*i,3)=dataSheet(:,12); % choiceMade
          data(((i-1)*numTrials)+1:numTrials*i,4)=dataSheet(:,9); % reward
          
    end
    
    save('data');
    writematrix(data,'mb_postmod.csv');
%     
%     data=zeros(numTrials*iterations,4);
%     
%     for i=1:iterations
%         data(((i-1)*numTrials)+1:numTrials*i,1)=i;
%         
%           simulate_Qmf;
%           
%           data(((i-1)*numTrials)+1:numTrials*i,2)=dataSheet(:,13); % commonRare
%           data(((i-1)*numTrials)+1:numTrials*i,3)=dataSheet(:,12); % choiceMade
%           data(((i-1)*numTrials)+1:numTrials*i,4)=dataSheet(:,9); % reward
%           
%     end
%     
%     save('data');
%     writematrix(data,'mf_postmod.csv')
%     
%     
    
    
end