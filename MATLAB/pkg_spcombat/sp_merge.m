function L2 = sp_merge(L,img)
for threshold = 1:27
    el = unique(L);
    el(end+1) = el(end) + 1;
    [counting,dict] = histcounts(L(:),el);
    target = dict(counting==threshold);
    for obs = 1:numel(target)
        inx = find(L == target(obs));
        [i,j,k] = ind2sub(size(L),inx);
        
        signal = mean(img(inx));
        coor = [];
        
        temp = find(i==min(i));
        coor = [coor;[i(temp)-1,j(temp),k(temp)]];
        temp = find(i==max(i));
        coor = [coor;[i(temp)+1,j(temp),k(temp)]];
        
        temp = find(j==min(j));
        coor = [coor;[i(temp),j(temp)-1,k(temp)]];
        temp = find(j==max(j));
        coor = [coor;[i(temp),j(temp)+1,k(temp)]];
        
        temp = find(k==min(k));
        coor = [coor;[i(temp),j(temp),k(temp)-1]];
        temp = find(k==max(k));
        coor = [coor;[i(temp),j(temp),k(temp)+1]];

        coor(coor==0) = 1; % limit those outside the bb
        for dim = 1:3
            val = coor(:,dim);
            val(val>size(L,dim)) = size(L,dim);
            coor(:,dim) = val;
        end
        
        coor2 = sub2ind(size(L),coor(:,1),coor(:,2),coor(:,3));
        coor2 = unique(coor2);
        x = abs(img(coor2)-signal);
        if numel(x==min(x))>1
            coor3 = coor2(x==min(x));
            L(inx) = L(coor3(1));
        else
            L(inx) = L(coor2(x==min(x)));
        end
    end
end
L2 = L;
end
