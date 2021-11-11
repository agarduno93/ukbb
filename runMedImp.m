%% Sherlock Imputation Code

%% Paths
dpath = getenv('DATACSV');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% number of parallel pool workers (usually 20 for 1 node on sherlock)
%parpool('local', 20, 'AttachedFiles', {fullfile(dcode,'gapDur.m'),fullfile(dcode,'medianImputation.m')})

% Loop through list of files
for i = 1:length(fns)
    try
        files = gunzip(fullfile(dpath,fns{i}));
        dt = readtable(files{1},'Delimiter', ',');
        dt2 = readtable(files{1});
        ttt=[];
        for jj = 1:length(dt2.Var2)
            ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
        end
      
        if sum(dt.imputed)>0
            gaps = gapDur(~dt.imputed);
            medianimputed = medianImputation(dt.acc,ttt,gaps);
            dt.acc_med = medianimputed;
        else
            dt.acc_med = dt.acc;
        end
        writetable(dt,fullfile(dpath,sprintf('%s-timeSeries.csv',fns{i})),'Delimiter',',')
    catch
    end
end
