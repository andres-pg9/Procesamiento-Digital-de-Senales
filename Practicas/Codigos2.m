signal = app.downSignal_2.Value;
            amplitud = app.sliderAmplitud_2.Value;
            frecuencia = app.sliderFrec_2.Value;

            tmin = str2double(get(app.txtTMin_2, 'Value'));
            tmax = str2double(get(app.txtTMax_2, 'Value'));

            escalamiento = str2double(get(app.txtEscala_2, 'Value'));
            reflexion = app.cboxReflex_2.Value;
            desplazamiento = str2double(get(app.txtDespla_2, 'Value'));   

            switch signal
                case 2 %SENOIDAL
                    if app.radioCont.Value == 1
                        puntoTiempo = 1000;
                    else
                        puntoTiempo = 100;
                    end
                    t2 = linspace(tmin+desplazamiento , tmax+desplazamiento, puntoTiempo);
                    x = 2 * pi * frecuencia * t2;
                        
                    if reflexion == 1 %Reflexión -> escalamiento = -1
                        aux = escalamiento * (x + desplazamiento);
                        y = amplitud * sin( aux * -1); %Señal desplazada, escalada y reflejada
                    else
                        y = amplitud * sin( escalamiento * (x + desplazamiento)); %Señal desplazada y escalada
                    end

                    if app.radioCont.Value == 1
                        plot(app.axes,t2, y,'m','LineWidth', 2); 
                    elseif app.radioDisc.Value == 1
                        stem(app.axes,t2, y,'m','LineWidth', 2); 
                    end

                case 3 %EXPONENCIAL
                    Fs = 10; 
                    t = tmin:1/Fs:tmax;
                    t2 = tmin+desplazamiento:1/Fs:tmax+desplazamiento; 
    
                    if reflexion == 1 
	                    aux = amplitud.^( escalamiento * (t + desplazamiento));
	                    y = fliplr(aux);
                    else
                        y = amplitud.^ (escalamiento * (t + desplazamiento));    
                    end

                    if app.radioCont.Value == 1
                        plot(app.axes,t2, y,'m','LineWidth', 2); 
                    elseif app.radioDisc.Value == 1
                        stem(app.axes,t2, y,'m','LineWidth', 2); 
                    end

                case 4 %RAMPA
                    if app.radioCont.Value == 1
                        puntoTiempo = 10000;
                    else
                        puntoTiempo = 10;
                    end
    
                    Fs = puntoTiempo;
                
                    ta = 0:1/Fs:tmax;
                    tb = tmax:1/Fs:tmax*2;
                    t = [ta,tb];
                    t2= [escalamiento * (ta + desplazamiento), escalamiento * (tb + desplazamiento)];
                
                    r = linspace(0, amplitud, length(ta));
                    y1 = amplitud.*[zeros(1,length(ta)),r];
                
                    if reflexion == 1
                        t2= [(escalamiento * (ta + desplazamiento))*-1, (escalamiento * (tb + desplazamiento))*-1];
                    end
                
                    y2 = amplitud.*[zeros(1,length(ta)),r];

                case 5 %CUADRADA
                    if app.radioCont.Value == 1
                        puntoTiempo = 1000;
                    else
                        puntoTiempo = 100;
                    end
    
                    duty = 50;
                    t = linspace(tmin, tmax, puntoTiempo);
                    t2 = linspace(tmin+desplazamiento , tmax+desplazamiento, puntoTiempo);
                    
                    x = 2*pi*frecuencia*t;
                    
                    y1 = amplitud*square(x,duty); 
                    
                    if reflexion == 1
                        aux = escalamiento * (x + desplazamiento);
	                    y2 = amplitud * square( aux * -1, duty); 
                    else
                        y2 = amplitud * square( escalamiento * (x + desplazamiento),duty);
                    end                      

                case 6 %TRIANGULAR
                    if app.radioCont.Value == 1
                        puntoTiempo = 1000;
                    else
                        puntoTiempo = 100;
                    end
                    
                    t = linspace(tmin, tmax, puntoTiempo);
                    t2 = linspace(tmin+desplazamiento , tmax+desplazamiento, puntoTiempo);
                                        
                    x = 2*pi*t;
                    y1 = amplitud*sawtooth(x,0.5);
                                        
                    if reflexion == 1 
                        aux = escalamiento * (x + desplazamiento);
	                    y2 = amplitud * sawtooth( aux * -1,0.5);
                    else
                        y2 = amplitud * sawtooth( escalamiento * (x + desplazamiento),0.5); 
                    end

                case 7 %ESCALON UNITARIO
                    if app.radioCont.Value == 1
                        puntoTiempo = 1000;
                    else
                        puntoTiempo = 100;
                    end
    
                    t = linspace(tmin, tmax, puntoTiempo);
                    t2 = linspace(tmin+ desplazamiento, tmax+ desplazamiento, puntoTiempo);
                        
                    y1 =  heaviside(t); 
                    %x2 =  heaviside(t2)*escalamiento;
                        
                    if reflexion == 1
                        aux = escalamiento * (heaviside(t2) );
                        y2 = aux * -1; 
                    else
                        y2 = escalamiento * (heaviside(t2) );
                    end

                case 8 %IMPULSO UNITARIO
                    t = tmin:tmax;
                    t2 = (tmin+ desplazamiento): (tmax+ desplazamiento);
    
                    y1 = amplitud.*[zeros(1,3),ones(1,1),zeros(1,2)]; 
                    y2 = (amplitud*escalamiento).*[zeros(1,3),ones(1,1),zeros(1,2)];

            end