
%% Simple example
vid = videoinput('gentl', 1, 'Mono8');

% src = getselectedsource(vid);
% 
% src.BlackLevel = 38;
% src.ContrastShape = 2;
% src.ExposureTime = 49999.03125;
% src.Gain = 24;

vid.FramesPerTrigger = 1;

figure(1)
subplot(1,2,1)
handle1 = image(zeros(2464, 2056));
preview(vid, handle1 );

subplot(1,2,2)
handle2 = image(zeros(2464, 2056));
preview(vidobj, handle2 );

%% Example 2

vidobj = imaq.VideoDevice('gentl', 1);
vidobj.ReturnedColorSpace = 'grayscale';

preview(vidobj)

%% Create a figure window.
% Create a video input object.

vid = videoinput('gentl', 1, 'Mono8');

% Create a figure window. This example turns off the default
% toolbar and menubar in the figure.
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name','My Custom Preview GUI');

% Set up the push buttons
uicontrol('String', 'Start Preview',...
    'Callback', 'preview(vid)',...
    'Units','normalized',...
    'Position',[0 0 0.15 .07]);
uicontrol('String', 'Stop Preview',...
    'Callback', 'stoppreview(vid)',...
    'Units','normalized',...
    'Position',[.17 0 .15 .07]);
uicontrol('String', 'Close',...
    'Callback', 'close(gcf)',...
    'Units','normalized',...
    'Position',[0.34 0 .15 .07]);

% Create the text label for the timestamp
hTextLabel = uicontrol('style','text','String','Timestamp', ...
    'Units','normalized',...
    'Position',[0.85 -.04 .15 .08]);

% Create the image object in which you want to
% display the video preview data.
vidRes = vid.VideoResolution;
imWidth = vidRes(1);
imHeight = vidRes(2);
nBands = vid.NumberOfBands;
hImage = image( zeros(imHeight, imWidth, nBands) );

% Specify the size of the axes that contains the image object
% so that it displays the image at the right resolution and
% centers it in the figure window.
figSize = get(hFig,'Position');
figWidth = figSize(3);
figHeight = figSize(4);
gca.unit = 'pixels';
gca.position = [ ((figWidth - imWidth)/2)... 
               ((figHeight - imHeight)/2)...
               imWidth imHeight ];

% Set up the update preview window function.
setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);

% Make handle to text label available to update function.
setappdata(hImage,'HandleToTimestampLabel',hTextLabel);

preview(vid, hImage);




function mypreview_fcn(obj,event,himage)
    % Example update preview window function.

    % Get timestamp for frame.
    tstampstr = event.Timestamp;

    % Get handle to text label uicontrol.
    ht = getappdata(himage,'HandleToTimestampLabel');

    % Set the value of the text label.
    ht.String = mean(event.Data(:));

    % Display image data.
    himage.CData = event.Data
    
end

