% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Grabar audio
% fs=44100; %f. muestreo
% segs = 3;
% senal_salida=audiorecorder(fs,16,1);%Creacion del objeto de grabacion
% msgbox('Empezando Grabacion',' Grabadora '); %Mensaje de informacion
% recordblocking(senal_salida,segs);%Grabacion del sonido
% msgbox('Terminando Grabacion',' Grabadora ');%Mensaje de informacion
% %Paso los valores del objeto a una señal
% senal_grabada=getaudiodata(senal_salida, 'single');
% %Grabamos y guardamos la señals
% audiowrite(uiputfile({'*.wav'},'Guardar como'),senal_grabada,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cargar audio
[y,Fs] = audioread(uigetfile({'*.wav'}, 'Abrir'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Reproducir audio
sound(y,Fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´Plotear señal
t = 0:seconds(1/Fs):seconds(length(y)./Fs);
t = t(1:end-1);
figure(1)
plot(t, y)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´Aplicar FFT

YT = fft(y);
figure(2)
plot(YT) 

L= length(y);

f1 = Fs*(0:(L/2))/L;
f2 = (-L/2:L/2-1)*(Fs/L);

P2 = abs(YT/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(3)
plot(f1,P1) 
title('Amplitud Espectral de y(t) (Single)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(4)
plot(f2,P2) 
title('Amplitud Espectral de y(t) (double)')
xlabel('f (Hz)')
ylabel('|P2(f)|')

% % n = length(y);
% % YT = fft(y);
% % f = (0:n-1)*(Fs/n);     %frequency range
% % power = abs(YT).^2/n;    %power
% % plot(f,power)
% % 
% % 
% % Ys = fftshift(YT);
% % fshift = (-n/2:n/2-1)*(Fs/n); % zero-centered frequency range
% % powershift = abs(Ys).^2/n;     % zero-centered power
% % plot(fshift,powershift)
% 
% 
% %%  V E N T A N E O
% 

H =  blackman(length(y));
YT = YT.*H;


figure(5)
plot(YT);

NW= fft(H);

ventaneo = conv(NW, YT);

figure(6);
plot(ventaneo);
 
 
L= length(y);
f1 = Fs*(0:(L/2))/L;
f2 = (-L/2:L/2-1)*(Fs/L);
P2 = abs(YT/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure(7);
plot(f1,P1) 
title('Amplitud Espectral de ventaneo (Single)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´Filtrar FFT
% %   % % MIERCOLES
% % 
% %   
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´RECUPERAR SEÑAL
nueva = ifft(P2);
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´Plotear señal
figure(8)
plot(nueva);
% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%´reproducir señal
% sound(abs(nueva),Fs)
