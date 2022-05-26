%% Sherlock Imputation Code

%% Paths
dpath = getenv('DATACSV');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% Loop through list of files
for i = 1:length(fns)
    try
        if strcomp(fns{i}(end-2:end),'.gz')
            files = gunzip(fullfile(dpath,fns{i}));
        end
	
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
        writetable(dt,fullfile(dpath,fns{i}),'Delimiter',',')
	delete fullfile(dpath,fns{i})
    catch
    end
end
