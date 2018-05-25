%only including elecs in both configs


a_config = [1:64,NaN*ones(1,27),92:111,NaN*ones(1,7)];
b_config = [1:64,NaN*ones(1,32),92:111,NaN*ones(1,2)];

for e = 1:length(b_config)
    if ~isnan(b_config(e))
        new_ind = find(a_config==b_config(e));
        if (~isempty(new_ind))
            dprime2.(['e',num2str(e)])=dprime.(['e',num2str(new_ind)]);
            p2.(['e',num2str(e)])=p.(['e',num2str(new_ind)]);
            HFB2.(['e',num2str(e)])=HFB.(['e',num2str(new_ind)]);
        end
    end
end
