%% Sherlock Imputation Code

%% Paths
dpath = getenv('DATACSV');
dcomm = getenv('DATACOMM');
fcomm = getenv('FILE');

fns = importdata(fullfile(dcomm,fcomm));


parpool('local', str2num(getenv('SLURM_CPUS_PER_TASK')))


for i = 1:length(fns)
    files = gunzip(fullfile(dpath,fns{i}));
    dt = readtable(fullfile(dpath,files{1}),'Delimiter', ',');
    dt2 = readtable(fullfile(dpath,fns{i}));
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
end


%% Median Imputation Function 
function medianimputed = medianImputation(act,t,gaps)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    medianimputed = act;
    tHrs = hour(t)+minute(t)/60 + second(t)/3600;
    for q = 1:size(gaps,1)
        
        gapTime = t(gaps(q,1)+1:gaps(q,2));
        
        gapHrs = hour(gapTime)+minute(gapTime)/60 + second(gapTime)/3600;
        
        impval = nan(length(gapHrs),1);
        for qq = 1:length(gapHrs)
            all_vals = act(tHrs==gapHrs(qq));
            vals = all_vals(all_vals~=0);
            impval(qq) = median(vals);
        end
        
        medianimputed(gaps(q,1)+1:gaps(q,2)) = impval;
    end
end

%% Gap Function
function gaps = gapDur(notGap_ind)
%gapDur finds the start and stop indices of gaps in 1D data
%   Detailed explanation goes here
    gaps = [find(diff(~notGap_ind)>0),ones(length(find(diff(~notGap_ind)>0)),1);...
        find(diff(~notGap_ind)<0),zeros(length(find(diff(~notGap_ind)<0)),1)];
    gaps = sortrows(gaps);
    
    if rem(size(gaps,1),2) == 1
        if gaps(end,2) == 1
            gaps = [gaps;length(notGap_ind),0];
        end
        
        if gaps(1,2) == 0
            gaps = [1,1;gaps];
        end
    end
    starts = gaps(gaps(:,2)==1,1);
    stops = gaps(gaps(:,2)==0,1);
    gaps = [starts,stops];
end
