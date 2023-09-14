% Cargar audio
[y, Fs] = audioread('Combinado.wav'); 

% Plotear señal de entrada
t = (0:length(y)-1)/Fs;
figure(1)
subplot(2,1,1)
plot(t, y)
title('Señal de entrada')
xlabel('Tiempo (s)')
ylabel('Amplitud')

% Aplicar FFT
YT = fft(y);

% Cálculo de amplitud espectral
L = length(y);
f = Fs*(0:(L/2))/L;
P2 = abs(YT/L);
P1 = P2(1:L/2+1);

% Plotear espectro de frecuencia de entrada
subplot(2,1,2)
plot(f, P1)
title('Espectro de frecuencia de entrada')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud')

% Banda de frecuencia a conservar (250-350 Hz)
frec_inicio = find(f >= 250, 1);
frec_fin = find(f <= 350, 1, 'last');
P1(frec_inicio:frec_fin) = 0; % Atenua las amplitudes fuera de la banda de frecuencia deseada

% Aplicar transformada inversa de Fourier
nueva = ifft(YT);

% Crear archivo de audio con la señal filtrada
audioFiltrado = 'AudioFiltrado.wav';
audiowrite(audioFiltrado, abs(nueva), Fs); 
disp('Audio filtrado guardado correctamente.');

% Plotear señal filtrada
figure(2)
subplot(2,1,1)
plot(t, nueva)
title('Señal filtrada')
xlabel('Tiempo (s)')
ylabel('Amplitud')

% Reproducir señal filtrada
sound(nueva, Fs)

% Plotear espectro de frecuencia filtrado
subplot(2,1,2)
plot(f, P1)
title('Espectro de frecuencia filtrado')
xlabel('Frecuencia (Hz)')
ylabel('Amplitud')