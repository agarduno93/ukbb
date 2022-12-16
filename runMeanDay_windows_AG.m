%% Sherlock Mean Day

%% Paths
%dpath = getenv('DATACSV');
%avgDaypath = getenv('DATAAVGDAY');
%dcode = getenv('CODEUKBB');
%dcomm = getenv('DATACOMM');
%fcomm = getenv('FILE');
dpath = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\DATACSV";
avgDaypath = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\DATACSV";
dcode = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\Commands";
dcomm = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\GitHub";
fcomm2 = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\DATACSV\P10001_15sec.csv";
fcomm = "C:\Users\Alexis Garduno\Dropbox\WHI_RAR_Accelerometry\DATACSV\P10001_15sec.csv";

% Get list of files to run
fns = importdata(fcomm2);

% number of parallel pool workers (usually 20 for 1 node on sherlock)
%parpool('local', 20, 'AttachedFiles', {fullfile(dcode,'gapDur.m'),fullfile(dcode,'medianImputation.m')})

% Loop through list of files
for i = 1:length(fns)
    try
        dt = readtable(fcomm2);
        dt2 = dt;
        ttt=[];
        for jj = 1:length(dt2.Time_POSIX)
        %ttt = [ttt;datetime(dt2.Var1(jj)) + duration(dt2.Var2{jj}(1:12))];
        %add 15 seonds to datetime;
        ttt = [ttt;datetime(dt2.Time_POSIX(jj),'InputFormat','MM/dd/yyyy hh:mm:ss a') + duration(0,1,0)];
        end
        
        dt.VM;
        tmins = 60*hour(ttt)+minute(ttt)+(second(ttt)./60);
        times = unique(tmins);
        
        dayMin = nan(1,length(times)); 
        for j = 1:length(times)
            dayMin(j) = mean(dt.VM(tmins == times(j)));
        end 
        Subject =  dt.OPACH_ID(1:1440);   
        T = [table(Subject),array2table(transpose(dayMin))];

        writetable(T,fullfile(avgDaypath,sprintf('%s-avgDay.csv',Subject{1})),'Delimiter',',')
    catch
    end
end
