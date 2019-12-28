function varargout = imrestorationGUI(varargin)
% IMRESTORATIONGUI MATLAB code for imrestorationGUI.fig
%      IMRESTORATIONGUI, by itself, creates a new IMRESTORATIONGUI or raises the existing
%      singleton*.
%
%      H = IMRESTORATIONGUI returns the handle to a new IMRESTORATIONGUI or the handle to
%      the existing singleton*.
%
%      IMRESTORATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMRESTORATIONGUI.M with the given input arguments.
%
%      IMRESTORATIONGUI('Property','Value',...) creates a new IMRESTORATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imrestorationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imrestorationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imrestorationGUI

% Last Modified by GUIDE v2.5 12-Dec-2016 11:42:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imrestorationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @imrestorationGUI_OutputFcn, ...
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


% --- Executes just before imrestorationGUI is made visible.
function imrestorationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imrestorationGUI (see VARARGIN)

% Choose default command line output for imrestorationGUI
handles = guihandles;
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
handles.axeHs = findobj(handles.figure1, 'type', 'axes');
[~, idx] = sort(get(handles.axeHs, 'Tag'));
handles.axeHs = handles.axeHs(idx);
handles.openFigures = {};
guidata(hObject, handles);
resetAxes();

% UIWAIT makes imrestorationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imrestorationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function imshowAs(image, axhandle)
imshow(image, 'Parent', axhandle);

function histPlotAs(xdata, ydata, axhandle, varargin)
axes(axhandle);
ydata = ydata / sum(ydata);
bar(xdata, ydata, 'FaceColor', 'b', 'EdgeColor', 'k');
if nargin < 4 || ~varargin{1}
    xlim([0, 1]);
else
    xlim([min(xdata), max(xdata)]);
end
ylim([0, max(ydata)]);
axhandle.YTickLabel = {};

function resetAxes()
handles = guidata(gcf);
if isfield(handles, 'polyH')
    delete(handles.polyH);
end
handles.pushbutton7.Enable = 'off';
handles.radiobutton1.Enable = 'off';
handles.radiobutton2.Enable = 'off';
set(findall(handles.degpanel, '-property', 'enable'), 'enable', 'off')
set(findall(handles.respanel, '-property', 'enable'), 'enable', 'off')
set(handles.radiobutton1, 'Value', 1);
set(handles.radiobutton2, 'Value', 0);
for i = 1:length(handles.axeHs)
    ax = handles.axeHs(i);
    cla(ax, 'reset');
    ax.Visible = 'off';
end

function showHistograms(noiseData, inputData, degData)
data = guidata(gcf);
xbins = linspace(0, 1, 256);
if length(unique(noiseData(:))) == 3
    nbins = 16;
else
    nbins = 256;
end
[noiseHist, centers] = hist(noiseData(:), nbins);

histPlotAs(centers, noiseHist, data.axeHs(5), true);
inputHist = hist(inputData(:), xbins);
histPlotAs(xbins, inputHist(:), data.axeHs(6))
degradedHist = hist(degData(:), xbins);
histPlotAs(xbins, degradedHist, data.axeHs(7))


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('images', 'dir')
    defaultPath = 'images/';
else
    defaultPath = '';
end
[imageName, imagePath] = uigetfile({'*.jpg;*.png;*.bmp;*.tif;*.jpeg', 'Images'}, 'Open an image...', defaultPath);
if imageName == 0
    return
end
resetAxes();
handles.originalImage = im2double(imread(fullfile(imagePath, imageName)));
handles.inputImage = handles.originalImage;
imshowAs(handles.inputImage, handles.axeHs(1));
set(findall(handles.degpanel, '-property', 'enable'), 'enable', 'on')
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetAxes()
handles.inputImage = rgb2gray(handles.originalImage);
imshowAs(handles.inputImage, handles.axeHs(1));
set(findall(handles.degpanel, '-property', 'enable'), 'enable', 'on')
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetAxes();
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetAxes();
handles.inputImage = handles.originalImage;
imshowAs(handles.inputImage, handles.axeHs(1));
set(findall(handles.degpanel, '-property', 'enable'), 'enable', 'on')
guidata(hObject, handles);

% --- Executes on selection change in degpopupmenu.
function degpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to degpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns degpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from degpopupmenu
contents = cellstr(get(hObject,'String'));
degradationType = strtrim(lower(contents{get(hObject,'Value')}));
switch degradationType
    case 'gaussian noise'
        handles.degParamName1.String = 'mean';
        handles.degParamVal1.String = '0.0';
        handles.degParamName1.Visible = 'on';
        handles.degParamVal1.Visible = 'on';
        handles.degParamName2.String = 'variance';
        handles.degParamVal2.String = '0.01';
        handles.degParamName2.Visible = 'on';
        handles.degParamVal2.Visible = 'on';
    case 'salt & pepper noise'
        handles.degParamName1.String = 'salt probability';
        handles.degParamVal1.String = '0.05';
        handles.degParamName1.Visible = 'on';
        handles.degParamVal1.Visible = 'on';
        handles.degParamName2.String = 'pepper probability';
        handles.degParamVal2.String = '0.05';
        handles.degParamName2.Visible = 'on';
        handles.degParamVal2.Visible = 'on';
    case 'uniform noise'
        handles.degParamName1.String = 'limit - low';
        handles.degParamVal1.String = '-0.1';
        handles.degParamName1.Visible = 'on';
        handles.degParamVal1.Visible = 'on';
        handles.degParamName2.String = 'limit - high';
        handles.degParamVal2.String = '0.1';
        handles.degParamName2.Visible = 'on';
        handles.degParamVal2.Visible = 'on';
    case 'exponential noise'
        handles.degParamName1.String = 'lambda';
        handles.degParamVal1.String = '10';
        handles.degParamName1.Visible = 'on';
        handles.degParamVal1.Visible = 'on';
        handles.degParamName2.Visible = 'off';
        handles.degParamVal2.Visible = 'off';
    case 'blurring'
        handles.degParamName1.String = 'sigma';
        handles.degParamVal1.String = '2';
        handles.degParamName1.Visible = 'on';
        handles.degParamVal1.Visible = 'on';
        handles.degParamName2.Visible = 'off';
        handles.degParamVal2.Visible = 'off';
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function degpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function degParamVal1_Callback(hObject, eventdata, handles)
% hObject    handle to degParamVal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of degParamVal1 as text
%        str2double(get(hObject,'String')) returns contents of degParamVal1 as a double


% --- Executes during object creation, after setting all properties.
function degParamVal1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degParamVal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function degParamVal2_Callback(hObject, eventdata, handles)
% hObject    handle to degParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of degParamVal2 as text
%        str2double(get(hObject,'String')) returns contents of degParamVal2 as a double


% --- Executes during object creation, after setting all properties.
function degParamVal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to degParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
resetAxes();
imshowAs(handles.inputImage, handles.axeHs(1));
set(findall(handles.degpanel, '-property', 'enable'), 'enable', 'on')

contents = cellstr(get(handles.degpopupmenu,'String'));
degradationType = strtrim(lower(contents{get(handles.degpopupmenu,'Value')}));
switch degradationType
    case 'gaussian noise'
        a = str2double(handles.degParamVal1.String);
        b = str2double(handles.degParamVal2.String);
        degradation = 'noise';
        noiseType = 'gaussian';
    case 'salt & pepper noise'
        a = str2double(handles.degParamVal1.String);
        b = str2double(handles.degParamVal2.String);
        degradation = 'noise';
        noiseType = 'salt & pepper';
    case 'uniform noise'
        a = str2double(handles.degParamVal1.String);
        b = str2double(handles.degParamVal2.String);
        degradation = 'noise';
        noiseType = 'uniform';
    case 'exponential noise'
        a = str2double(handles.degParamVal1.String);
        b = 0;
        degradation = 'noise';
        noiseType = 'exponential';
    case 'rayleigh noise'
        a = str2double(handles.degParamVal1.String);
        b = str2double(handles.degParamVal2.String);
        degradation = 'noise';
        noiseType = 'rayleigh';
    case 'blurring'
        a = str2double(handles.degParamVal1.String);
        degradation = 'blur';
end
if strcmpi(degradation, 'noise')
    handles.noiseImage = noiseGen(handles.inputImage, noiseType, a, b);
    handles.degImage = imdegrade(handles.inputImage, degradation, handles.noiseImage);
    imshowAs(handles.noiseImage, handles.axeHs(2))
    showHistograms(handles.noiseImage, handles.inputImage, handles.degImage);
    handles.pushbutton7.Enable = 'on';
    handles.radiobutton1.Enable = 'on';
else
    handles.degImage = imdegrade(handles.inputImage, degradation, a);
end
imshowAs(handles.degImage, handles.axeHs(3))

set(findall(handles.respanel, '-property', 'enable'), 'enable', 'on');
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.respopupmenu,'String'));
restorationType = strtrim(lower(contents{get(handles.respopupmenu,'Value')}));
switch restorationType
    case 'mean filter'
        a = str2double(handles.resParamVal1.String);
        b = str2double(handles.resParamVal2.String);
        restoration = 'mean';
    case 'median filter'
        a = str2double(handles.resParamVal1.String);
        b = str2double(handles.resParamVal2.String);
        restoration = 'median';
    case 'min filter'
        a = str2double(handles.resParamVal1.String);
        b = str2double(handles.resParamVal2.String);
        restoration = 'min';
    case 'max filter'
        a = str2double(handles.resParamVal1.String);
        b = str2double(handles.resParamVal2.String);
        restoration = 'max';
    case 'sharpening'
        a = str2double(handles.resParamVal1.String);
        b = str2double(handles.resParamVal2.String);
        restoration = 'sharpen';
end
if strcmpi(restoration, 'sharpen')
    handles.restoredImage = imrestore(handles.degImage, restoration, a, b);
else
    handles.restoredImage = imrestore(handles.degImage, restoration, [a b]);
end
imshowAs(handles.restoredImage, handles.axeHs(4));
guidata(hObject, handles);

function resParamVal2_Callback(hObject, eventdata, handles)
% hObject    handle to resParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resParamVal2 as text
%        str2double(get(hObject,'String')) returns contents of resParamVal2 as a double


% --- Executes during object creation, after setting all properties.
function resParamVal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to resParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resParamVal2 as text
%        str2double(get(hObject,'String')) returns contents of resParamVal2 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resParamVal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in respopupmenu.
function respopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to respopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns respopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from respopupmenu
contents = cellstr(get(hObject,'String'));
restorationType = strtrim(lower(contents{get(hObject,'Value')}));
switch restorationType
    case 'mean filter'
        handles.resParamName1.String = 'kernel size';
        handles.resParamVal1.String = '3';
        handles.resParamName1.Visible = 'on';
        handles.resParamVal1.Visible = 'on';
        handles.resParamName2.String = '';
        handles.resParamVal2.String = '3';
        handles.resParamName2.Visible = 'on';
        handles.resParamVal2.Visible = 'on';
    case 'median filter'
        handles.resParamName1.String = 'kernel size';
        handles.resParamVal1.String = '3';
        handles.resParamName1.Visible = 'on';
        handles.resParamVal1.Visible = 'on';
        handles.resParamName2.String = '';
        handles.resParamVal2.String = '3';
        handles.resParamName2.Visible = 'on';
        handles.resParamVal2.Visible = 'on';
    case 'min filter'
        handles.resParamName1.String = 'kernel size';
        handles.resParamVal1.String = '3';
        handles.resParamName1.Visible = 'on';
        handles.resParamVal1.Visible = 'on';
        handles.resParamName2.String = '';
        handles.resParamVal2.String = '3';
        handles.resParamName2.Visible = 'on';
        handles.resParamVal2.Visible = 'on';
    case 'max filter'
        handles.resParamName1.String = 'kernel size';
        handles.resParamVal1.String = '3';
        handles.resParamName1.Visible = 'on';
        handles.resParamVal1.Visible = 'on';
        handles.resParamName2.String = '';
        handles.resParamVal2.String = '3';
        handles.resParamName2.Visible = 'on';
        handles.resParamVal2.Visible = 'on';
    case 'sharpening'
        handles.resParamName1.String = 'strength';
        handles.resParamVal1.String = '0.5';
        handles.resParamName1.Visible = 'on';
        handles.resParamVal1.Visible = 'on';
        handles.resParamName2.String = 'sigma';
        handles.resParamVal2.String = '3';
        handles.resParamName2.Visible = 'on';
        handles.resParamVal2.Visible = 'on';
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function respopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'polyH')
    delete(handles.polyH);
end
handles.polyH = impoly(handles.axeHs(1));
mask = handles.polyH.createMask;

if size(handles.inputImage, 3) > 1
    mask = repmat(mask, [1, 1, 3]);
end
handles.roiInput = handles.inputImage(mask == 1);
handles.roiDeg = handles.degImage(mask == 1);

showHistograms(handles.noiseImage, handles.roiInput, handles.roiDeg);

set(handles.radiobutton1, 'Value', 0);
set(handles.radiobutton2, 'Value', 1);
handles.radiobutton2.Enable = 'on';
guidata(hObject, handles);

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
showHistograms(handles.noiseImage, handles.inputImage, handles.degImage);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
if isfield(handles, 'polyH')
    showHistograms(handles.noiseImage, handles.roiInput, handles.roiDeg);
end

function zoomImage(imageVariable, figTitle)
handles = guidata(gcf);
if isfield(handles, imageVariable)
    figHandle = handles.figure1;
    warning('off', 'images:initSize:adjustingMag')
    image = getfield(handles, imageVariable);
    hf = figure('Name', figTitle, 'IntegerHandle', 'off');
    imshow(image);
    handles.openFigures{end + 1} = hf;
    guidata(figHandle, handles);
    warning('on', 'images:initSize:adjustingMag')
end


% --------------------------------------------------------------------
function uipanel2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('inputImage', 'Input image');


% --------------------------------------------------------------------
function uipanel5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('noiseImage', 'Noise');


% --------------------------------------------------------------------
function uipanel6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('degImage', 'Degraded image');


% --------------------------------------------------------------------
function uipanel7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('restoredImage', 'Restored image');


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
for i = 1:length(handles.openFigures)
    hf = handles.openFigures{i};
    if isvalid(hf)
        close(hf);
    end
end
delete(hObject);
