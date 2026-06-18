function[MAT_BASE] = calc_MAT_BASE(Lspread)
Nc = 2^floor(log2(Lspread))-1;
MAT_BASE = crea_all_mlc(Nc);
if Nc < Lspread
    MAT_BASE = [MAT_BASE -ones(size(MAT_BASE,1),1)];
end
Nc = Nc + 1;
if Nc < Lspread
    MAT_BASE = (resample(MAT_BASE.',Lspread,Nc)).';
end;
