function varargout = fftGUI(varargin)
% FFTGUI MATLAB code for fftGUI.fig
%      FFTGUI, by itself, creates a new FFTGUI or raises the existing
%      singleton*.
%
%      H = FFTGUI returns the handle to a new FFTGUI or the handle to
%      the existing singleton*.
%
%      FFTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FFTGUI.M with the given input arguments.
%
%      FFTGUI('Property','Value',...) creates a new FFTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fftGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fftGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fftGUI

% Last Modified by GUIDE v2.5 12-Dec-2016 13:50:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fftGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @fftGUI_OutputFcn, ...
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


% --- Executes just before fftGUI is made visible.
function fftGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fftGUI (see VARARGIN)

% Choose default command line output for fftGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.axeHs = findobj(handles.figure1, 'type', 'axes');
[~, idx] = sort(get(handles.axeHs, 'Tag'));
handles.axeHs = handles.axeHs(idx);
handles.openFigures = {};
guidata(hObject, handles);
resetAxes();
% UIWAIT makes fftGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fftGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function resetAxes()
handles = guidata(gcf);
for i = 1:length(handles.axeHs)
    ax = handles.axeHs(i);
    cla(ax, 'reset');
    ax.Visible = 'off';
end

function imshowAs(image, axhandle)
imshow(image, [], 'Parent', axhandle);

function zoomImage(imageVariable, figTitle)
handles = guidata(gcf);
if isfield(handles, imageVariable)
    figHandle = handles.figure1;
    warning('off', 'images:initSize:adjustingMag')
    image = getfield(handles, imageVariable);
    hf = figure('Name', figTitle, 'IntegerHandle', 'off');
    imshow(image, []);
    handles.openFigures{end + 1} = hf;
    guidata(figHandle, handles);
    warning('on', 'images:initSize:adjustingMag')
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch deblank(lower(handles.uibuttongroup2.SelectedObject.String))
    case 'cameramangrid'
        funcName = 'artifact_removal1';
    case 'freqdist'
        fileName = 'images/freqdist.png';
        if ~exist(fileName, 'file')
            errordlg(['Required image file "' fileName '" missing!'], 'Missing input file');
            return
        end
        funcName = 'artifact_removal2';
end

resetAxes();
[handles.outputImage, handles.inputImage, handles.inputFFT, handles.modifiedFFT] = eval(funcName);
imshowAs(handles.inputImage, handles.axeHs(1));
imshowAs(handles.inputFFT, handles.axeHs(2));
imshowAs(handles.modifiedFFT, handles.axeHs(3));
imshowAs(handles.outputImage, handles.axeHs(4));
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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
handles.inputImage = im2double(imread(fullfile(imagePath, imageName)));
if size(handles.inputImage, 3) > 1
    handles.inputImage = rgb2gray(handles.inputImage);
end
imshowAs(handles.inputImage, handles.axeHs(1));
guidata(hObject, handles);


% --------------------------------------------------------------------
function uipanel1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('inputImage', 'Input image');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch deblank(lower(handles.uibuttongroup1.SelectedObject.String))
    case 'low-pass filter'
        HLparam = 'low';
    case 'high-pass filter'
        HLparam = 'high';
end
fsize = str2double(handles.edit1.String);
[handles.outputImage, handles.inputFFT, handles.modifiedFFT] = HLpassFilter(handles.inputImage, fsize,HLparam);
imshowAs(handles.inputFFT, handles.axeHs(2));
imshowAs(handles.modifiedFFT, handles.axeHs(3));
imshowAs(handles.outputImage, handles.axeHs(4));


% --------------------------------------------------------------------
function uipanel2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('inputFFT', 'FFT input');

% --------------------------------------------------------------------
function uipanel3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('modifiedFFT', 'Modified FFT');

% --------------------------------------------------------------------
function uipanel4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoomImage('outputImage', 'Output image');

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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
resetAxes()
handles.pushbutton1.Visible = 'on';
handles.pushbutton2.Visible = 'off';
handles.pushbutton3.Visible = 'off';
handles.text1.Visible = 'off';
handles.edit1.Visible = 'off';
handles.uibuttongroup2.Visible = 'on';

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
resetAxes()
if isfield(handles, 'inputImage')
    imshowAs(handles.inputImage, handles.axeHs(1));
end
handles.pushbutton1.Visible = 'off';
handles.pushbutton2.Visible = 'on';
handles.pushbutton3.Visible = 'on';
handles.text1.Visible = 'on';
handles.edit1.Visible = 'on';
handles.uibuttongroup2.Visible = 'off';

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
resetAxes()
if isfield(handles, 'inputImage')
    imshowAs(handles.inputImage, handles.axeHs(1));
end
handles.pushbutton1.Visible = 'off';
handles.pushbutton2.Visible = 'on';
handles.pushbutton3.Visible = 'on';
handles.text1.Visible = 'on';
handles.edit1.Visible = 'on';
handles.uibuttongroup2.Visible = 'off';
