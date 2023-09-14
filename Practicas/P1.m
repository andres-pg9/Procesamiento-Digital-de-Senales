t = linspace(-pi,pi,500); %Creando un vector de -pi a pi con 500 elementos

y1 = sin(t); %Funciones sen y cos
y2 = cos(t);

plot(t, y1, 'b', 'LineWidth', 2),grid on; %Grafica del seno respecto al tiempo
hold on; %Mantener la gráfica del seno para mostrar la del coseno

plot(t, y2, 'r', 'LineWidth', 2); %Gráfica del coseno respecto al tiempo
hold off; %Desactivar modo hold