function img2 = sp_para_constrain_ds(img1)
vec = reshape(img1,numel(img1),1);
vec = vec(vec>=1+0.00001 | vec<=1-0.00001);
m1 = median(vec,'omitnan'); s1 = mad(vec,1);
img2 = img1; img2(img2 >= m1 + 10*s1) = NaN; img2(img2 <= m1 - 10*s1) = NaN;
end