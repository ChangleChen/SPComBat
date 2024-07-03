function vec2 = sp_uni_row(vec1)
i = size(vec1);
if i(1)>i(2)
    vec2 = transpose(vec1);
else
    vec2 = vec1;
end
end