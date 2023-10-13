% MidiLogger
% Record .mid files via MATLAB from digital music instruments. Built on Ken
% Schutte's matlab-midi: https://kenschutte.com/midi/
% Also see MATLAB Midi devices documentation:
% https://www.mathworks.com/help/audio/ug/midi-device-interface.html
% Author: Ravi Umadi, 2023

% Parameters
noteOn = 144:144+16; % See midi specs 
% https://midi.org/specifications-old/category/reference-tables
noteOff = 127:127+16;

% Define the MIDI input device ID
availableDevices = mididevinfo;

% Edit the line below for slecting your device
midiInputID = availableDevices.input(1).ID;

% Define path for storing midi files
if ~exist('rec', 'dir')
    mkdir('rec')
end
recpath = "rec";

% Get user name. If not needed, also remove from midiFileName, see below
username = [];
while isempty(username)
    username = input("Enter the name of the player:     ", 's');
end

% Creare a midi device
midiIn = mididevice(midiInputID);

% Define the MIDI file name (seems unused, but included it anyway)
midiFileName = fullfile(recpath, strcat(string(datetime('now',...
    'format', 'uuuu-MM-dd-HH-mm-ss-')), username, '.mid'));

% Define midi matrix
MidiMatrix = zeros(1,6);

figure; % Create a figure to capture the key press

% Initialize flag to stop loop
global stopLoop;
stopLoop = false;

% Set the key press function
set(gcf, 'KeyPressFcn', @(src, event) checkKeyPress(event));

% Prompt begin
disp("Press 's' to start recording")

% Wait for 's' key to start the loop
while true
    waitforbuttonpress;
    if gcf().CurrentCharacter == 's'
        break;
    end
end

disp("Recording started... Press 'x' to stop.");

% Loop until 'x' key is pressed
while ~stopLoop
    % Receive MIDI messages
    midiMessages = midireceive(midiIn);

    % Check if there are new messages
    if ~isempty(midiMessages)
        % Loop through the received MIDI messages
        for i = 1:numel(midiMessages)
            midiMessage = midiMessages(i);

            % Check note on/off
            if ismember(midiMessage.MsgBytes(1), noteOn)
                entryCol = 5;
            elseif ismember(midiMessage.MsgBytes(1), noteOff)
                entryCol = 6;
            else
                continue; % ignore control commands
            end
            
            % Add to the matrix. See examples in matlab-midi
            MidiMatrix(end+1,[1:4, entryCol]) = [1, midiMessage.Channel,...
                double(midiMessage.MsgBytes(2)), ...
                double(midiMessage.MsgBytes(3)), midiMessage.Timestamp];
        end
    end

    % Optional: Add a delay to control the rate of recording
    pause(0.1); % Adjust the delay as needed
end

% Close the figure
close(gcf);

% Process notes and write out midi file
MidiMatrix(1,:) = [];
midiFileStructure = matrix2midi(MidiMatrix);
if exist('midiFileStructure', 'var')
    writemidi(midiFileStructure, midiFileName);
end

clear midiIn;

% % Process midi file in system
% ! timidity -o output.wav -Ow output.mid
% ! play output.wav

% Function to check key press
function checkKeyPress(event)
global stopLoop;
if strcmp(event.Key, 'x')
    stopLoop = true;
    disp("Recording Stopped");
end
end
