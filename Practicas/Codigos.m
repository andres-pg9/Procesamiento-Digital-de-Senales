classdef P5_1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        window1                      matlab.ui.Figure
        btnWindow                    matlab.ui.control.Button
        cboxReflex                   matlab.ui.control.CheckBox
        txtDespla                    matlab.ui.control.EditField
        EscalamientodeTiempoLabel_3  matlab.ui.control.Label
        txtEscala                    matlab.ui.control.EditField
        EscalamientodeTiempoLabel_2  matlab.ui.control.Label
        ReflexinLabel                matlab.ui.control.Label
        txtTMax                      matlab.ui.control.EditField
        TiempoMxLabel                matlab.ui.control.Label
        txtTMin                      matlab.ui.control.EditField
        TiempoMinEditFieldLabel      matlab.ui.control.Label
        sliderFrec                   matlab.ui.control.Slider
        FrecuenciaLabel              matlab.ui.control.Label
        sliderAmplitud               matlab.ui.control.Slider
        AmplitudSliderLabel          matlab.ui.control.Label
        downSignal                   matlab.ui.control.DropDown
        SealDropDownLabel            matlab.ui.control.Label
        txtTitulo                    matlab.ui.control.Label
        btnGraficar                  matlab.ui.control.Button
        groupRep                     matlab.ui.container.ButtonGroup
        radioDisc                    matlab.ui.control.RadioButton
        radioCont                    matlab.ui.control.RadioButton
        axes2                        matlab.ui.control.UIAxes
        axes                         matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: btnGraficar
        function btnGraficarPushed(app, event)
            signal = app.downSignal.Value;
            amplitud = app.sliderAmplitud.Value;
            frecuencia = app.sliderFrec.Value;

            t1 = get(app.txtTMin, 'Value');
            tmin = str2double(t1);

            t2 = get(app.txtTMax, 'Value');
            tmax = str2double(t2);

            escTiem = get(app.txtEscala, 'Value');
            escalamiento = str2double(escTiem);

            reflexion = app.cboxReflex.Value;

            despTiem = get(app.txtDespla, 'Value');
            desplazamiento = str2double(despTiem);    

            function signalSeno(puntoTiempo)
                t = linspace(tmin, tmax, puntoTiempo); 
                t2 = linspace(tmin+desplazamiento , tmax+desplazamiento, puntoTiempo);
                    
                x = 2 * pi * frecuencia * t;

                y1 = amplitud * sin(x); %Señal original
                    
                if reflexion == 1 %Reflexión -> escalamiento = -1
                    aux = escalamiento * (x + desplazamiento);
                    y2 = amplitud * sin( aux * -1); %Señal desplazada, escalada y reflejada
                else
                    y2 = amplitud * sin( escalamiento * (x + desplazamiento)); %Señal desplazada y escalada
                end
                
            end
            
            function signalExp()
                Fs = 10; 
                n = tmin:1/Fs:tmax;
                n2 = tmin+desplazamiento:1/Fs:tmax+desplazamiento; 
                    
                x = amplitud.^ n; 

                if reflexion == 1 
	                aux = amplitud.^( escalamiento * (n + desplazamiento));
	                x2 = fliplr(aux);
                else
                    x2 = amplitud.^ (escalamiento * (n + desplazamiento));    
                end
            end

            function signalRamp(puntoTiempo)
                Fs = puntoTiempo;
            
                t1 = 0:1/Fs:tmax;
                t2 = tmax:1/Fs:tmax*2;
                t = [t1,t2];
                %t_esc= [escalamiento * (t1 + desplazamiento), escalamiento * (t2 + desplazamiento)];
            
                r = linspace(0, amplitud, length(t1));
                x = amplitud.*[zeros(1,length(t1)),r];
            
                if reflexion == 1
                    %t_esc= [(escalamiento * (t1 + desplazamiento))*-1, (escalamiento * (t2 + desplazamiento))*-1];
                end
            
                x2 = amplitud.*[zeros(1,length(t1)),r];
            end

            function signalCuad(puntoTiempo)
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
            end

            function signalTrian (puntoTiempo)
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
            end



            if signal == 2 %% Senoidal
                if app.radioCont.Value == 1 
                    %% Continuo                 
                    signalSeno(1000);
                    plot(app.axes,t, y1,'b','LineWidth', 2); 
                    plot(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Senoidal Continuo';
                    
                elseif app.radioDisc.Value == 1 
                    %% Discreto
                    signalSeno(100);
                    stem(app.axes,t, y1,'b','LineWidth', 2); 
                    stem(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Senoidal Discreto'; 
                end

            elseif signal == 3 %% Exponencial
               if app.radioCont.Value == 1
                    %% Continuo
                    
                    signalExp();
                    plot(app.axes,n, x,'b','LineWidth', 2); 
                    plot(app.axes2,n2, x2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Exponencial Continuo'; 
               elseif app.radioDisc.Value == 1
                    %% Discreto
                    signalExp();
                    stem(app.axes,n,x,'b','LineWidth', 2);
                    stem(app.axes2,n2, x2,'m','LineWidth', 2);
                    app.axes.Title.String ='Exponencial Discreto'; 
               end
            
            elseif signal == 4 %% Rampa
                if app.radioCont.Value == 1
                    %% Continuo
                    %% CAMBIAR t por t_esc en axes2
                    signalRamp(10000);
                    plot(app.axes, t, x, 'b', 'LineWidth', 2);
                    plot(app.axes2, t, x2, 'm', 'LineWidth', 2); 
                    app.axes.Title.String = 'Rampa Continuo';

               elseif app.radioDisc.Value == 1
                   %% Discreto
                   %% CAMBIAR t por t_esc en axes2
                   signalRamp(10);
                   stem(app.axes,t, x,'b','LineWidth', 2); 
                   stem(app.axes2,t, x2,'m','LineWidth', 2); 
                   app.axes.Title.String ='Rampa Discreto'; 
               end
            elseif signal == 5 %% Cuadrada
                if app.radioCont.Value == 1
                    %% Continuo               
                    signalCuad(1000);                    
                    plot(app.axes,t,y1,'b','LineWidth', 2);
                    plot(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Cuadrada Continuo'; 
               elseif app.radioDisc.Value == 1
                    %% Discreto
                    signalCuad(100);     
                    stem(app.axes,t,y1,'b','LineWidth', 2);
                    stem(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Cuadrada Discreto'; 
               end
            elseif signal == 6 %% Triangular
                if app.radioCont.Value == 1
                    %% Continuo
                    signalTrian(1000);
                    plot(app.axes,t, y1,'b','LineWidth', 2); 
                    plot(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Triangular Continuo'; 

               elseif app.radioDisc.Value == 1
                   %% Discreto
                    signalTrian(100);
                    stem(app.axes,t, y1,'b','LineWidth', 2); 
                    stem(app.axes2,t2, y2,'m','LineWidth', 2); 
                    app.axes.Title.String ='Triangular Discreto';
               end
            elseif signal == 7 %% Escalón Unitario
                if app.radioCont.Value == 1
                   %% Continuo
                    t = linspace(tmin, tmax, 1000);
                    t2 = linspace(tmin+ desplazamiento, tmax+ desplazamiento, 1000);
                    
                    x =  heaviside(t); % Generación de la señal
                    %x2 =  heaviside(t2)*escalamiento;
                    
                    if reflexion == 1 %Reflexión -> escalamiento = -1
                        aux = escalamiento * (heaviside(t2) );
                        x2 = aux * -1; 
                    else
                        x2 = escalamiento * (heaviside(t2) );
                    end

                    plot(app.axes,t, x,'b','LineWidth', 2); % Grafica la señal
                    %hold(app.axes,'on');

                    plot(app.axes2,t2, x2,'m','LineWidth', 2); %Señal modificada
                    %hold(app.axes,"off");
                    app.axes.Title.String ='Escalón Unitario Continuo'; 
               elseif app.radioDisc.Value == 1
                   %% Discreto
                    t = linspace(tmin, tmax, 100);
                    t2 = linspace(tmin+ desplazamiento, tmax+ desplazamiento, 100);
                    
                    x =  heaviside(t); % Generación de la señal
                    %x2 =  heaviside(t2)*escalamiento;
                    
                    if reflexion == 1 %Reflexión -> escalamiento = -1
                        aux = escalamiento * (heaviside(t2) );
                        x2 = aux * -1; 
                    else
                        x2 = escalamiento * (heaviside(t2) );
                    end

                    stem(app.axes,t, x,'b','LineWidth', 2); % Grafica la señal
                    %hold(app.axes,'on');

                    stem(app.axes2,t2, x2,'m','LineWidth', 2); %Señal modificada
                    %hold(app.axes,"off");
                    app.axes.Title.String ='Escalón Unitario Discreto';
               end
            elseif signal == 8 %% Impulso unitario
                   n = tmin:tmax; %Tiempo de Simulación
                   n2 = (tmin+ desplazamiento): (tmax+ desplazamiento);

                   x = amplitud.*[zeros(1,3),ones(1,1),zeros(1,2)]; %Generación de Señal
                   x2 = (amplitud*escalamiento).*[zeros(1,3),ones(1,1),zeros(1,2)]; %Generación de Señal

                   stem(app.axes,n,x,'b','LineWidth', 2); %Gráfica
                   %hold(app.axes,'on');

                   stem(app.axes2,n2, x2,'m','LineWidth', 2); %Señal modificada
                   %hold(app.axes,"off");
                   app.axes.Title.String ='Impulso Unitario'; 
            end
        end

        % Button pushed function: btnWindow
        function btnWindowButtonPushed(app, event)
            P5_2
            app.window1.Visible = 'off';
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create window1 and hide until all components are created
            app.window1 = uifigure('Visible', 'off');
            app.window1.Position = [100 100 974 710];
            app.window1.Name = 'MATLAB App';

            % Create axes
            app.axes = uiaxes(app.window1);
            title(app.axes, 'Gráfica')
            xlabel(app.axes, 'Tiempo (s)')
            ylabel(app.axes, 'Amplitud')
            zlabel(app.axes, 'Z')
            app.axes.FontWeight = 'bold';
            app.axes.YLim = [-10 10];
            app.axes.YTick = [-10 -5 0 5 10];
            app.axes.YTickLabel = {'-10'; '-5'; '0'; '5'; '10'};
            app.axes.XGrid = 'on';
            app.axes.YGrid = 'on';
            app.axes.FontSize = 14;
            app.axes.Position = [7 331 475 323];

            % Create axes2
            app.axes2 = uiaxes(app.window1);
            title(app.axes2, 'Gráfica')
            xlabel(app.axes2, 'Tiempo (s)')
            ylabel(app.axes2, 'Amplitud')
            zlabel(app.axes2, 'Z')
            app.axes2.FontWeight = 'bold';
            app.axes2.YLim = [-10 10];
            app.axes2.YTick = [-10 -5 0 5 10];
            app.axes2.YTickLabel = {'-10'; '-5'; '0'; '5'; '10'};
            app.axes2.XGrid = 'on';
            app.axes2.YGrid = 'on';
            app.axes2.FontSize = 14;
            app.axes2.Position = [481 331 475 323];

            % Create groupRep
            app.groupRep = uibuttongroup(app.window1);
            app.groupRep.Title = 'Representación';
            app.groupRep.FontWeight = 'bold';
            app.groupRep.FontSize = 14;
            app.groupRep.Position = [35 195 227 63];

            % Create radioCont
            app.radioCont = uiradiobutton(app.groupRep);
            app.radioCont.Text = 'Continua';
            app.radioCont.FontWeight = 'bold';
            app.radioCont.Position = [16 11 74 22];
            app.radioCont.Value = true;

            % Create radioDisc
            app.radioDisc = uiradiobutton(app.groupRep);
            app.radioDisc.Text = 'Discreta';
            app.radioDisc.FontWeight = 'bold';
            app.radioDisc.Position = [134 11 69 22];

            % Create btnGraficar
            app.btnGraficar = uibutton(app.window1, 'push');
            app.btnGraficar.ButtonPushedFcn = createCallbackFcn(app, @btnGraficarPushed, true);
            app.btnGraficar.FontSize = 14;
            app.btnGraficar.FontWeight = 'bold';
            app.btnGraficar.Position = [831 193 96 36];
            app.btnGraficar.Text = 'Graficar';

            % Create txtTitulo
            app.txtTitulo = uilabel(app.window1);
            app.txtTitulo.HorizontalAlignment = 'center';
            app.txtTitulo.FontSize = 18;
            app.txtTitulo.FontWeight = 'bold';
            app.txtTitulo.Position = [277 666 394 23];
            app.txtTitulo.Text = 'Operaciones sobre la variable Independiente';

            % Create SealDropDownLabel
            app.SealDropDownLabel = uilabel(app.window1);
            app.SealDropDownLabel.HorizontalAlignment = 'center';
            app.SealDropDownLabel.FontSize = 14;
            app.SealDropDownLabel.FontWeight = 'bold';
            app.SealDropDownLabel.Position = [35 285 47 22];
            app.SealDropDownLabel.Text = 'Señal:';

            % Create downSignal
            app.downSignal = uidropdown(app.window1);
            app.downSignal.Items = {'Seleccionar', 'Senoidal', 'Exponencial', 'Rampa', 'Cuadrada', 'Triangular', 'Escalón Unitario', 'Impulso Unitario'};
            app.downSignal.ItemsData = [1 2 3 4 5 6 7 8];
            app.downSignal.FontSize = 14;
            app.downSignal.FontWeight = 'bold';
            app.downSignal.Position = [93 285 168 22];
            app.downSignal.Value = 1;

            % Create AmplitudSliderLabel
            app.AmplitudSliderLabel = uilabel(app.window1);
            app.AmplitudSliderLabel.HorizontalAlignment = 'right';
            app.AmplitudSliderLabel.FontSize = 14;
            app.AmplitudSliderLabel.FontWeight = 'bold';
            app.AmplitudSliderLabel.Position = [290 280 66 22];
            app.AmplitudSliderLabel.Text = 'Amplitud';

            % Create sliderAmplitud
            app.sliderAmplitud = uislider(app.window1);
            app.sliderAmplitud.Limits = [0 10];
            app.sliderAmplitud.FontSize = 14;
            app.sliderAmplitud.FontWeight = 'bold';
            app.sliderAmplitud.Position = [377 290 352 3];
            app.sliderAmplitud.Value = 4;

            % Create FrecuenciaLabel
            app.FrecuenciaLabel = uilabel(app.window1);
            app.FrecuenciaLabel.HorizontalAlignment = 'right';
            app.FrecuenciaLabel.FontSize = 14;
            app.FrecuenciaLabel.FontWeight = 'bold';
            app.FrecuenciaLabel.Position = [277 218 79 22];
            app.FrecuenciaLabel.Text = 'Frecuencia';

            % Create sliderFrec
            app.sliderFrec = uislider(app.window1);
            app.sliderFrec.Limits = [0 10];
            app.sliderFrec.FontSize = 14;
            app.sliderFrec.FontWeight = 'bold';
            app.sliderFrec.Position = [380 228 345 3];
            app.sliderFrec.Value = 1;

            % Create TiempoMinEditFieldLabel
            app.TiempoMinEditFieldLabel = uilabel(app.window1);
            app.TiempoMinEditFieldLabel.HorizontalAlignment = 'right';
            app.TiempoMinEditFieldLabel.FontSize = 14;
            app.TiempoMinEditFieldLabel.FontWeight = 'bold';
            app.TiempoMinEditFieldLabel.Position = [291 149 87 22];
            app.TiempoMinEditFieldLabel.Text = 'Tiempo Min:';

            % Create txtTMin
            app.txtTMin = uieditfield(app.window1, 'text');
            app.txtTMin.FontWeight = 'bold';
            app.txtTMin.Position = [393 149 49 22];
            app.txtTMin.Value = '0';

            % Create TiempoMxLabel
            app.TiempoMxLabel = uilabel(app.window1);
            app.TiempoMxLabel.HorizontalAlignment = 'right';
            app.TiempoMxLabel.FontSize = 14;
            app.TiempoMxLabel.FontWeight = 'bold';
            app.TiempoMxLabel.Position = [539 149 90 22];
            app.TiempoMxLabel.Text = 'Tiempo Máx:';

            % Create txtTMax
            app.txtTMax = uieditfield(app.window1, 'text');
            app.txtTMax.FontWeight = 'bold';
            app.txtTMax.Position = [644 147 49 22];
            app.txtTMax.Value = '5';

            % Create ReflexinLabel
            app.ReflexinLabel = uilabel(app.window1);
            app.ReflexinLabel.FontSize = 14;
            app.ReflexinLabel.FontWeight = 'bold';
            app.ReflexinLabel.Position = [414 91 68 22];
            app.ReflexinLabel.Text = 'Reflexión';

            % Create EscalamientodeTiempoLabel_2
            app.EscalamientodeTiempoLabel_2 = uilabel(app.window1);
            app.EscalamientodeTiempoLabel_2.HorizontalAlignment = 'right';
            app.EscalamientodeTiempoLabel_2.FontSize = 14;
            app.EscalamientodeTiempoLabel_2.FontWeight = 'bold';
            app.EscalamientodeTiempoLabel_2.Position = [54 91 174 22];
            app.EscalamientodeTiempoLabel_2.Text = 'Escalamiento de Tiempo:';

            % Create txtEscala
            app.txtEscala = uieditfield(app.window1, 'text');
            app.txtEscala.FontWeight = 'bold';
            app.txtEscala.Position = [243 91 49 22];
            app.txtEscala.Value = '1';

            % Create EscalamientodeTiempoLabel_3
            app.EscalamientodeTiempoLabel_3 = uilabel(app.window1);
            app.EscalamientodeTiempoLabel_3.HorizontalAlignment = 'right';
            app.EscalamientodeTiempoLabel_3.FontSize = 14;
            app.EscalamientodeTiempoLabel_3.FontWeight = 'bold';
            app.EscalamientodeTiempoLabel_3.Position = [554 91 215 22];
            app.EscalamientodeTiempoLabel_3.Text = 'Desplazamiento de Tiempo: t + ';

            % Create txtDespla
            app.txtDespla = uieditfield(app.window1, 'text');
            app.txtDespla.FontWeight = 'bold';
            app.txtDespla.Position = [784 91 49 22];
            app.txtDespla.Value = '0';

            % Create cboxReflex
            app.cboxReflex = uicheckbox(app.window1);
            app.cboxReflex.Text = '';
            app.cboxReflex.Position = [390 91 25 22];

            % Create btnWindow
            app.btnWindow = uibutton(app.window1, 'push');
            app.btnWindow.ButtonPushedFcn = createCallbackFcn(app, @btnWindowButtonPushed, true);
            app.btnWindow.FontSize = 14;
            app.btnWindow.FontWeight = 'bold';
            app.btnWindow.Position = [397 23 180 45];
            app.btnWindow.Text = 'Variable Dependiente';

            % Show the figure after all components are created
            app.window1.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = P5_1

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.window1)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.window1)
        end
    end
end