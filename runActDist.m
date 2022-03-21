%% Sherlock Activity data Distribution
% bins of size 20 from 0 to 4000
%% Paths
dpath = getenv('DATACSV');
actDistpath = getenv('DATAACTDIST');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% number of parallel pool workers (usually 20 for 1 node on sherlock)
%parpool('local', 20, 'AttachedFiles', {fullfile(dcode,'gapDur.m'),fullfile(dcode,'medianImputation.m')})

% Pre-allocate Distribution 
ActDist = [[1:length([0:20:4000])];zeros(1,length([0:20:4000]))]';

% Loop through list of files
for i = 1:length(fns)
    % Load Data
    dt = readtable(fullfile(dpath,fns{i}),'Delimiter', ',');
    dt2 = readtable(fullfile(dpath,fns{i}));
    ttt=[];
    for jj = 1:length(dt2.Var2)
        ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
    end
        
    tmins = 60*hour(ttt)+minute(ttt)+(second(ttt)./60);
    times = unique(tmins);

	
	if ~ismember('acc_med',dt.Properties.VariableNames)
        if sum(dt.imputed)>0
            gaps = gapDur(~dt.imputed);
            medianimputed = medianImputation(dt.acc,ttt,gaps);
            dt.acc_med = medianimputed;
        else
            dt.acc_med = dt.acc;
        end
        writetable(dt,fullfile(dpath,fns{i}),'Delimiter',',')
    end

    Y = discretize(dt.acc_med,[0:20:4000]);
	T = tabulate(Y);
	TT = array2table(T(:,1:2),'VariableNames',{'BinNum','Count'});
	Subject =  {fns{i}(1:end-15)};
    writetable(TT,fullfile(actDistpath,sprintf('%s-ActDist.csv',Subject{1})),'Delimiter',',');
    
    for j = 1:size(T,1)
        ind = find(ActDist(:,1) == T(j,1));
        ActDist(ind,2) = ActDist(ind,2) + T(j,2);
    end 
end

TTact = array2table(ActDist(:,1:2),'VariableNames',{'BinNum','Count'});
writetable(TTact,fullfile(actDistpath,'masterActDist.csv'),'Delimiter',',');
    



