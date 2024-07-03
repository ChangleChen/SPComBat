function img2 = sp_para_constrain_gs(img1)
vec = reshape(img1,numel(img1),1);
vec = vec(vec~=0); m1 = median(vec,'omitnan'); s1 = mad(vec,1);
img2 = img1; img2(img2 >= m1 + 10*s1) = NaN; img2(img2 <= m1 - 10*s1) = NaN;
end