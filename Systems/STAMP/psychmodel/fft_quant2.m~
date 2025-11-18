function [q_out] = mdct_quant(mdct_data,steps);

%find ceil max value to set to highest quantization level
q_max = max(mdct_data);
%calculate step size(delta)
q_out = (round(mdct_data/q_max*steps)/steps)*q_max;


