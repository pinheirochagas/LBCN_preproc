old_cats = 1:13;
new_cats = [1 7 2 2 8 8 5 6 6 3 NaN 4 NaN];

old_conds = conds;
conds = NaN*ones(1,length(old_conds));

for ci = 1:length(old_cats)
    tempi = find(old_conds==old_cats(ci));
    conds(tempi)=new_cats(ci);
end