function [q_out] = mdct_quant(mdct_data,bits);

%find ceil max value to set to highest quantization level
steps=2.^bits;
get_max = max(mdct_data);
get_min = min(mdct_data);
if abs(get_min)>get_max
q_max=get_min;
else
q_max=get_max;
end
%calculate step size(delta)
q_out = (round(mdct_data./q_max.*steps)./steps).*q_max;


