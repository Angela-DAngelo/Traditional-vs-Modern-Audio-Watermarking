function[g_mask]=globalmsk(t_thres,n_thres,tq)
%takes abs hearing threshold for each bin, and indiv masking thresholds from 4

g_mask=[];
t_sum=0;
n_sum=0;
if numel(t_thres) == 0
    g_mask = tq.';
else
    for i=1:1:size(t_thres,1)
        t_sum=0;
        n_sum=0;
        h_comp=10.^(0.1.*tq(i));
        if isempty(t_thres)==1
            t_sum=0;
        else
            for l=1:1:size(t_thres,2);
                t_comp=10.^(0.1.*t_thres(i,l));
                t_sum=t_sum+t_comp;
            end
        end
        if isempty(n_thres)==1
            n_sum=0;
        else
            for m=1:1:size(n_thres,2);
                n_comp=10.^(0.1.*n_thres(i,m));
                n_sum=n_sum+n_comp;
            end
        end
        all_comp=10.*log10(h_comp+t_sum+n_sum);
        g_mask=[g_mask;all_comp];
    end
end;