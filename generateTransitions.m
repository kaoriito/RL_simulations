function transMatrix = generateTransitions (numTrials, commonProb, minSet)
    
%     numTrials=225;
%     commonProb=0.7;
%     minSet=20;

    rampUp=4;
    
    transMatrix=[];
    chunk=[];


  %  rng(2);

    
    groups=numTrials/minSet;
    remainder=rem(numTrials,minSet);
    
    groupRare=minSet*(1-commonProb);
    
    for i=1:groups
        
        for j=1:2
            groupAr=ones(minSet,1);

            if i==1 
                % in the case of the first set, the first few (rampUp) will always be
                % the common transition
                rareIndex=randperm(20-rampUp,round(groupRare))+rampUp;
            else 
                rareIndex=randperm(20,round(groupRare));
            end

            consec=diff(sort(rareIndex));

            while sum(consec(:)==1)>=3

                if i==1 
                    % in the case of the first set, the first few (rampUp) will always be
                    % the common transition
                    rareIndex=randperm(20-rampUp,round(groupRare))+rampUp;
                else 
                    rareIndex=randperm(20,round(groupRare));
                end

                consec=diff(sort(rareIndex));

             end

            groupAr(rareIndex)=0;

            chunk(1:minSet,j)=groupAr;
        end

        transMatrix(1+(minSet*(i-1)):(minSet*i),1)=chunk(:,1);
        transMatrix(1+(minSet*(i-1)):(minSet*i),2)=chunk(:,2);
   
    end
    
    
    %% take care of the remaining values that didn't fit into a chunk of minSet
    if remainder > 0
       lastChunk=ones(remainder,2);
       
       remainderRare=remainder*(1-commonProb);
       rareIndexEnd1=randperm(remainder,floor(remainderRare));
       rareIndexEnd2=randperm(remainder,floor(remainderRare));
       lastChunk(rareIndexEnd1,1)=0;
       lastChunk(rareIndexEnd2,2)=0;
     
       transMatrix=vertcat(transMatrix,lastChunk);
    end

end