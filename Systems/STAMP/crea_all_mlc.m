function[gold_seq] = crea_all_mlc(Nc)
%Genera sequenze di Gold di lunghezza Nc
% 4 	15      [4 3]       [4 3]
% 5 	31      [5 2]       [5 4 3 2]
% 6 	63      [6 1]       [6 5 2 1]
% 7 	127 	[7 3]       [7 3 2 1]
% 8 	255 	[2 3 4 8]   [3 5 6 8]
% 9 	511 	[9 4]       [9 6 4 3]
% 10 	1023 	[10 3]      [10 8 3 2]
% 11 	2047 	[11 2]      [11 8 5 2]
m = log2(Nc+1);
if m == 2
    Reg1 = [2 1];
    Reg2 = [2 1];
elseif m == 3
    Reg1 = [3 2];
    Reg2 = [3 2];
elseif m == 4
    Reg1 = [4 3];
    Reg2 = [4 3];    
elseif m == 5
    Reg1 = [5 2];
    Reg2 = [5 4 3 2];
elseif m == 6
    Reg1 = [6,1];
    Reg2 = [6 5 2 1];
elseif m == 7
    Reg1 = [7 3];
    Reg2 = [7 3 2 1];
elseif m == 8
    Reg1 = [2 3 4 8];
    Reg2 = [3 5 6 8];   
elseif m == 9
    Reg1 = [9 4];
    Reg2 = [9 6 4 3];       
elseif m == 10
    Reg1 = [10 3];
    Reg2 = [10 8 3 2];       
elseif m == 11
    Reg1 = [11 2];
    Reg2 = [11 8 5 2];   
end;    

seq_base = crea_mlc(m,Reg1);
Nc = length(seq_base);
gold_seq = zeros(Nc-1,Nc);
for kl = 1:Nc-1
   gold_seq(kl,kl:Nc) = seq_base(1:Nc-kl+1); 
   gold_seq(kl,1:kl-1) = seq_base(Nc-kl+2:Nc); 
end;
