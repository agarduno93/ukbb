%% Sherlock Mean Day
 

%% Paths
dpath = getenv('DATACSV');
avgDaypath = getenv('DATAAVGDAY');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% number of parallel pool workers (usually 20 for 1 node on sherlock)
%parpool('local', 20, 'AttachedFiles', {fullfile(dcode,'gapDur.m'),fullfile(dcode,'medianImputation.m')})

% Loop through list of files
for i = 1:length(fns)
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
            writetable(dt,fullfile(dpath,sprintf('%s-timeSeries.csv',fns{i})),'Delimiter',',')
        end

        dayMin = nan(1,length(times)); 
        for j = 1:length(times)
            dayMin(j) = mean(dt.acc_med(tmins == times(j)));
        end 
        Subject =  {fns{i}(1:end-15)};   
        T = [table(Subject),array2table(dayMin)];

        writetable(T,fullfile(avgDaypath,sprintf('%s-avgDay.csv',Subject{1})),'Delimiter',',');
end
