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

    % Pre-allocate Distribution 
    ActDist_Bins = zeros(1,length([0:20:4000,100000])); 

    Y = discretize(dt.acc_med,[0:20:4000,100000]);
    T = tabulate(Y);
    ActDist_inds = 1:length([0:20:4000,100000]);

    for j = 1:size(T,1)
        ind = find(ActDist_inds == T(j,1));
        ActDist_Bins(ind) = ActDist_Bins(ind) + T(j,2);
    end 

    TT = [array2table(ActDist_Bins)];

    Subject =  {fns{i}(1:end-15)};
    writetable(TT,fullfile(actDistpath,sprintf('%s-ActDist.csv',Subject{1})),'Delimiter',',');
     
end



