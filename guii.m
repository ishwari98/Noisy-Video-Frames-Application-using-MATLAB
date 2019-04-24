function varargout = guii(varargin)
% GUII MATLAB code for guii.fig
%      GUII, by itself, creates a new GUII or raises the existing
%      singleton*.
%
%      H = GUII returns the handle to a new GUII or the handle to
%      the existing singleton*.
%
%      GUII('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUII.M with the given input arguments.
%
%      GUII('Property','Value',...) creates a new GUII or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guii_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guii_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guii

% Last Modified by GUIDE v2.5 17-Apr-2019 15:08:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guii_OpeningFcn, ...
                   'gui_OutputFcn',  @guii_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guii is made visible.
function guii_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guii (see VARARGIN)

% Choose default command line output for guii
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guii wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guii_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file path] = uigetfile({'*.mp4',...
    'VIDEO Files (*.mp4)'},...
    '');
fullpathName = strcat(path, file);
workingDir = 'C:';
mkdir(workingDir);
mkdir(workingDir,'images');
setappdata(handles.browse, 'fullpathName', fullpathName);
setappdata(handles.browse, 'workingDir', workingDir);



% --- Executes on button press in split.
function split_Callback(hObject, eventdata, handles)
% hObject    handle to split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Video = VideoReader(getappdata(handles.browse, 'fullpathName'));
setappdata(handles.split, 'Video', Video);

ii = 1;
workingDir = getappdata(handles.browse, 'workingDir');
while hasFrame(Video)
   img = readFrame(Video);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end

imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

setappdata(handles.split, 'imageNames', imageNames);


% --- Executes on button press in salt_and_pepper.
function salt_and_pepper_Callback(hObject, eventdata, handles)
% hObject    handle to salt_and_pepper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageNames = getappdata(handles.split, 'imageNames');
workingDir = getappdata(handles.browse, 'workingDir');
mkdir(workingDir,'S&P');
noise = 0.03;
ii = 1;
for ii = 1:length(imageNames)
    im = imread(fullfile(workingDir,'images',imageNames{ii}));
    J = imnoise(im,'salt & pepper', noise);
    fileName = [sprintf('%03dSPNoise',ii) '.jpg'];
    fullName = fullfile(workingDir,'S&P',fileName);
    imwrite(J , fullName);
end

SPimgNames = dir(fullfile(workingDir,'S&P','*SPNoise.jpg'));
SPimgNames = {SPimgNames.name}';

setappdata(handles.salt_and_pepper, 'SPimgNames', SPimgNames);


% --- Executes on button press in gaussian.
function gaussian_Callback(hObject, eventdata, handles)
% hObject    handle to gaussian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageNames = getappdata(handles.split, 'imageNames');
workingDir = getappdata(handles.browse, 'workingDir');
mkdir(workingDir,'G')
noise = 0.03;
ii = 1;
for ii = 1:length(imageNames)
    im = imread(fullfile(workingDir,'images',imageNames{ii}));
    J = imnoise(im,'gaussian', noise);
    fileName = [sprintf('%03dGNoise',ii) '.jpg'];
    fullName = fullfile(workingDir,'G',fileName);
    imwrite(J , fullName);
end

GimgNames = dir(fullfile(workingDir,'G','*GNoise.jpg'));
GimgNames = {GimgNames.name}';

setappdata(handles.gaussian, 'GimgNames', GimgNames);


% --- Executes on button press in sp_video.
function sp_video_Callback(hObject, eventdata, handles)
% hObject    handle to sp_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Video = getappdata(handles.split, 'Video');
SPoutputVideo = VideoWriter(fullfile('SPoutput.avi'));
SPoutputVideo.FrameRate = Video.FrameRate;
open(SPoutputVideo)

SPimgNames = getappdata(handles.salt_and_pepper, 'SPimgNames');

workingDir = getappdata(handles.browse, 'workingDir');
ii = 1;
for ii = 1:length(SPimgNames)
   image = imread(fullfile(workingDir,'S&P',SPimgNames{ii}));
   writeVideo(SPoutputVideo,image)
end

close(SPoutputVideo);

implay('SPoutput.avi');


% --- Executes on button press in g_video.
function g_video_Callback(hObject, eventdata, handles)
% hObject    handle to g_video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Video = getappdata(handles.split, 'Video');
GoutputVideo = VideoWriter(fullfile('Goutput.avi'));
GoutputVideo.FrameRate = Video.FrameRate;
open(GoutputVideo)

GimgNames = getappdata(handles.gaussian, 'GimgNames');

workingDir = getappdata(handles.browse, 'workingDir');
ii = 1;
for ii = 1:length(GimgNames)
   image = imread(fullfile(workingDir,'G',GimgNames{ii}));
   writeVideo(GoutputVideo,image)
end

close(GoutputVideo)
implay('Goutput.avi');


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

workingDir = getappdata(handles.browse, 'workingDir');
images = fullfile(workingDir,'images');
sp = fullfile(workingDir,'S&P');
g = fullfile(workingDir,'G');
iFiles = dir(images);
sFiles = dir(sp);
gFiles = dir(g);
for k = 1 : length(iFiles)
  ibaseFileName = iFiles(k).name;
  ifullFileName = fullfile(images, ibaseFileName);
  fprintf(1, 'Now deleting %s\n', ifullFileName);
  delete(ifullFileName);
end
for k = 1 : length(sFiles)
  sbaseFileName = sFiles(k).name;
  sfullFileName = fullfile(sp, sbaseFileName);
  fprintf(1, 'Now deleting %s\n', sfullFileName);
  delete(sfullFileName);
end
for k = 1 : length(gFiles)
  gbaseFileName = gFiles(k).name;
  gfullFileName = fullfile(g, gbaseFileName);
  fprintf(1, 'Now deleting %s\n', gfullFileName);
  delete(gfullFileName);
end
close all;
