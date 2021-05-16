clear,clc;
t = (0:0.1:100.1);
x = sawtooth(t);
%plot(t,x)
y = awgn(x,10,'measured');
figure(1)
plot(t,[x; y])
legend('Original Signal','Signal with AWGN')

x_fft_d = abs(fft(x));
x_fft = x_fft_d(1:length(x_fft_d)/2+1);
y_fft_d = abs(fft(y));
y_fft = y_fft_d(1:length(y_fft_d)/2+1);
f_axis_d = (0:length(x)-1)*1000/length(x);
f_axis = f_axis_d(1:length(f_axis_d)/2+1);

figure(2)
plot(f_axis,[x_fft; y_fft])
legend('Original Signal','Signal with AWGN')

figure(3)
plot(f_axis,y_fft - x_fft);