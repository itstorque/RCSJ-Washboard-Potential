global tr phi_last L fr f update_counter

Phi02pi = 1/(2*pi);%2.07e-15 / (2*pi);
I = 0;
I_c = 2.5;
R = 1;
C = 1;

I = 1;
update_counter = 0;
    
L = 2;

phi_last = [0 0];
tr = linspace(0, 10, 1000);
fr = 2;

f = figure(1);
ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',I, 'min',0, 'max',5);
bgcolor = f.Color;
bl1 = uicontrol('Parent',f,'Style','text','Position',[50,54,23,23],...
                'String','0','BackgroundColor',bgcolor);
bl2 = uicontrol('Parent',f,'Style','text','Position',[500,54,23,23],...
                'String','1','BackgroundColor',bgcolor);
bl3 = uicontrol('Parent',f,'Style','text','Position',[240,25,100,23],...
                'String','Damping Ratio','BackgroundColor',bgcolor);
            
b.Callback = @(es,ed) stack_ode(es.Value, Phi02pi, I_c, R, C);

ode_update(I, Phi02pi, I_c, R, C)

function sys = stack_ode(I, Phi02pi, I_c, R, C)

    global update_counter
    
    update_counter = update_counter + 1;
    
    t = timer('StartDelay', 0.1, 'TimerFcn', @(src,evt) ode_update(I, Phi02pi, I_c, R, C));
    
    start(t)
    
end

function  sys  = ode_update(I, Phi02pi, I_c, R, C)

    disp('hi')

    global tr phi_last L fr f update_counter
    
    counter = update_counter;

    [ts, phis] = ode45(@(t,phi) func_dfpen(t, phi, Phi02pi, I, I_c, R, C), tr, phi_last);

    x = [ L*sin(phis(:,1))];
    y = [-L*cos(phis(:,1))];
    
    for id = 1:fr:length(ts)
        
        k = update_counter;

        if ~ishghandle(f) || k ~= counter
            disp('removed stack')
            break
        end
        
        figure(1)

        phi_last = phis(id, :);

        subplot(3,2,2);
        plot(ts,phis(:,1), 'LineWidth', 0.5);
        line(ts(id), phis(id,1), 'Marker', '.', 'MarkerSize', 20, 'Color', 'b');
        xlabel('time'); ylabel('\phi');

        subplot(3,2,4);
        plot(ts,phis(:,2), 'LineWidth', 0.5);
        line(ts(id), phis(id,2), 'Marker', '.', 'MarkerSize', 20, 'Color', 'b');
        xlabel('time'); ylabel('$$\dot \phi$$', 'interpreter','latex');

        subplot(3,2,6);
        plot(ts, -I*ts-cos(ts), 'LineWidth', 0.7);
        line(phis(:,1), -I*phis(:,1)-cos(phis(:,1)), 'color', 'r', 'LineWidth', 0.5);
        line(phis(id,1), -I*phis(id,1)-cos(phis(id,1)), 'Marker', '.', 'MarkerSize', 20, 'Color', 'b');
        xlabel('time'); ylabel('$$I / I_c$$', 'interpreter','latex');

        subplot(3,2,[1 3 5]);
        plot([0, x(id,1);], [0, y(id,1);], ...
            '.-', 'MarkerSize', 20, 'LineWidth', 2);
        axis equal; axis([-2*L 2*L -2*L 2*L]);
        title(sprintf('Time: %0.2f', ts(id)));

        drawnow;
    end
    
end

function  dphidt  = func_dfpen(t, phi, Phi02pi, I, I_c, R, C)
    dphidt(1) = phi(2);
    dphidt(2) = (- I_c * sin(phi(1)) - Phi02pi / R * phi(2) + I) / (Phi02pi * C);
    dphidt=dphidt(:);
end