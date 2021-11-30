%% Sherlock Mean Day
 

%% Paths
dpath = getenv('DATACSV');
MDYpath = getenv('DATAMDY');
dcode = getenv('CODEUKBB');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

% Get list of files to run
fns = importdata(fcomm);

% Loop through list of files
for i = 1:length(fns)
        dt2 = readtable(fullfile(dpath,fns{i}));

        t = datetime(dt2.Var1(1)) + duration(dt2.Var2{1}(1:12));

        Subject =  {fns{i}(1:end-15)};   
	

        if exist('T','var') == 1
		T = [T;table(Subject,t)];
	else
		T = table(Subject,t);
	end
	%writetable(T,fullfile(MDYpath,sprintf('%s-szn.m',fns{i}))
end
ind = find(fcomm == '_',1,'last');
writetable(T,fullfile(MDYpath,sprintf('11%s-szn.csv',fcomm(ind+1:end-4))))
