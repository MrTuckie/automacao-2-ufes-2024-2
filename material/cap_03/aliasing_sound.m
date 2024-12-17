function aliasing_sound
%built by keith regner 9/2016 with R2014b (8.4 OSX)
clear all
close all

%% description
% This demo demonstrates aliasing of a wave visually and aurally. An 
% ?analog? signal is created at frequency f = 1000 Hz and is ?digitally 
% sampled? at a sampling frequency Fs. The analog (solid blue lines) and 
% digital (red lines) signals are shown in the time domain (top plot) and 
% the frequency domain (bottom plot). Control Fs with the slider bar and 
% observe the change in the digital signal in both the time and frequency 
% domains. If Fs >> f, the digital signal is an excellent representation of 
% the analog signal. The Nyquist frequency is achieved when Fs = 2f and as 
% Fs decreases below 2f, aliasing occurs. Aliasing is most apparent in the 
% frequency domain plot (shift in the location of the spike), but can also 
% be heard by pressing the ?Play? button. Doing so will play the two 
% signals (first the analog signal, a slight pause, then the digital 
% signal). If aliasing is happening two different tones will clearly be 
% heard. 

%% create signals
b.harm = 1000;                        %frequency of the cosine wave
b.Fs_read = 21000;                    %sampling rate to read analog signal
slide_min = 1000;                     %max sampling frequency on slider
slide_max = 21000;                    %min sampling frequency on slider

b.Fs = 50000;                         %simulate analog signal with high Fs
b.t = 0:1/b.Fs:.5;                    %time vector for analog signal
b.t_read = 0:1/b.Fs_read:.5;          %time vector for digital signal

b.S = TD(b.harm,b.t);                 %generate analog signal
b.S_read = TD(b.harm,b.t_read);       %generate digitally read signal

%% create figure and axes
b.n = find(b.t>1/b.harm,1);
b.fig = figure('Units','inches','Position',[5 .25 8 8.3],...
    'Name','aliasing_sound','NumberTitle','off');
b.ax1 = axes('Units','inches','Position',[1 5 6 3],'FontSize',12,...
    'LineWidth',1.5,'XLim', [0 b.t(10*b.n)*1000],'YLim',[-.55 .55],...
    'Box','on');
hold on
b.ax2 = axes('Units','inches','Position',[1 1.3 6 3],'FontSize',12,...
    'LineWidth',1.5,'XScale','log','XLim', [0 b.Fs/2],'YLim',...
    [0 0.55],'Box','on','YTick',[0 0.1 0.2 0.3 0.4 0.5]);
b.ax1.XLabel.String = 'time [msec]';
b.ax1.YLabel.String = 'amplitude [a.u.]';
b.ax2.XLabel.String = 'frequency [Hz]';
b.ax2.YLabel.String = 'amplitude [a.u.]';

%% solution
%plot amplitude vs time for analog and digitally sampled signals
b.pl1a = plot(b.ax1,b.t*1000, b.S,'LineWidth',1.5);
hold on
b.pl1b = plot(b.ax1,b.t_read*1000, b.S_read,'-or','LineWidth',1.5);

%take fourier transform of analog signal
[b.f,b.P1] = FD(b.t,b.S,b.Fs);

%take fourier transform of digitally sampled signal
[b.f_read,b.P1_read] = FD(b.t_read,b.S_read,b.Fs_read);

%plot fourier transforms of analog and digitally sampled signals
b.pl2a = plot(b.ax2,b.f,b.P1,'LineWidth', 1.5);
hold on
b.pl2b = plot(b.ax2,b.f_read,b.P1_read,'r','LineWidth',1.5);
b.l2 = legend(b.ax2,{'analog signal','digitally sampled signal'},...
    'Location','NorthWest','Box','off','FontSize',12);

%% add user control to sample frequency
b.txtbox = annotation('textbox','Units','inches','Position',...
    [3.3 0.1 4 .3],'String',...
    ['{\itF}_s = ' num2str(b.Fs_read) ' Hz'],'FontSize',12,...
    'LineStyle','none');
b.sl = uicontrol('Parent',b.fig,'Style','slide','Units','inches',...
    'Position',[1.5 .5 5 .2],'Min',slide_min,'Max',slide_max,'Value',...
    b.Fs_read,'SliderStep',[1/500 1/40],'Tag','slider1',...
    'BackgroundColor',b.fig.Color,'UserData',...
    struct('FS',b.Fs_read,'SS',b.S_read),'Callback',{@slider_call,b});
b.label1 = uicontrol('Parent',b.fig,'Units','inches','Style',...
    'text','Position',[.8 .4 .6 .3],'String',num2str(slide_min),...
    'FontSize',12,'BackgroundColor',b.fig.Color);
b.label2 = uicontrol('Parent',b.fig,'Units','inches','Style',...
    'text','Position',[6.5 .4 .8 .3],'String',num2str(slide_max),...
    'FontSize',12,'BackgroundColor',b.fig.Color);
%add UI to play sound 
b.pb = uicontrol('Parent',b.fig,'Style','pushbutton','Units','inches',...
    'Position',[1.5 3 .4 .3],'Callback',{@button_call,b},...
    'BackgroundColor',b.fig.Color,'String','Play','FontSize',12);

set(findall(b.fig,'-property','FontUnits'),'FontUnits','normalized')
set(findall(b.fig,'-property','Units'),'Units','normalized')

end

%% slider function
function slider_call(varargin)
%callback for the slider
[H,b] = varargin{[1,3]};
Fs_new = H.Value;

%calculate new time domain signal
t_new = 0:1/Fs_new:.5;
[S_new] = TD(b.harm,t_new);

%calculate new frequency domain signal
[f_new,P1_new] = FD(t_new,S_new,Fs_new);

% %update plot and and indicators
set(b.txtbox,'String',['{\itF}_s = ' num2str(Fs_new) ' Hz'])
set(b.pl1b,'xdata',t_new*1000,'ydata',S_new)
set(b.pl2b,'xdata',f_new,'ydata',P1_new)

data = struct('FS',Fs_new,'SS',S_new);
H.UserData = data;
end

%% button function
function button_call(varargin)
[H,b] = varargin{[1,3]};
h = findobj('Tag','slider1');
data = h.UserData;
%play the analog signal
sound(b.S,b.Fs)
pause(2)
%play the digital signal
sound(data.SS,data.FS)
end

%% frequency domain
function [f,P1] = FD(t,S,Fs)
L = length(t)+1;
y = fft(S);
P2 = abs(y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
end

%% time domain
function [S] = TD(harm,t)
S = .5*cos(2*pi*harm*t);
% S = .15*cos(2*pi*harm*t) + .15*cos(2*pi*1.25*harm*t) + ...
%     .15*cos(2*pi*1.5*harm*t) + .15*cos(2*pi*2*harm*t);

end
