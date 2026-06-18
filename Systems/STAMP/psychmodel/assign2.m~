%clear workspace and figures
clc;clear all;close all;
%variable declaration
N = 512;
hop = 1;
n = 0:N-1;
max_value=0;
%read wav into local storage buffer
[pcm,Fs,nbits] = wavread('orig_bts.wav');
%separate channels into left/right vectors
max_frame = 0;
pcm_left = pcm(:,1);
pcm_right = pcm(:,2);
%calculate number of samples and frames
num_samples = length(pcm);
num_frames = num_samples/N;
%allocate memory for output matrix
output = zeros([num_samples,2]);
%create window function and transpose
w = sin((pi/N)*(n+1/2));
w = w';
fignum=1;
a=figure('Name','Global Masking Curve');
while hop+N-1 <= num_samples    
  %get frame to window 
  cur_frame_l = pcm_left(hop:hop+N-1);
  cur_frame_r = pcm_right(hop:hop+N-1);
  %normalize
  norm_l = normalizer(cur_frame_l,N);  
  norm_r = normalizer(cur_frame_r,N);    
  %apply window to normalized input
  left = norm_l.*w;
  right = norm_r.*w;
  %take fft
  fft_left = fft(left,N); 
  fft_right = fft(right,N);
  %calculate global masking curves
  gmask_l=psychmodel(fft_left);
  gmask_r=psychmodel(fft_right);
  %take mdct
  mdct_left = fast_mdct(left); 
  mdct_right = fast_mdct(right);
  %take ifft
  left = ifft(fft_left);
  right = ifft(fft_right);
  %take imdctt
  mdct_left = imdct(mdct_left);
  mdct_right = imdct(mdct_right);
  %reapply window
  left = left.*w;
  right = right.*w;
  %overlap and add left/right and update output
  output(hop:hop+N-1,1) = output(hop:hop+N-1,1) + left;
  output(hop:hop+N-1,2) = output(hop:hop+N-1,2) + right;
  %increment hop pointer
  hop = hop+N/2;
end
% figure(1);
% plot(pcm(:,1));
% figure(2);
% plot(output(:,1));
wavwrite(output,44100,'output.wav');