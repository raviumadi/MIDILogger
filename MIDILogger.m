clear all,
cls
% Parameters
noteOn = 144:144+16;
noteOff = 127:127+16;
% Define the MIDI input device ID
availableDevices = mididevinfo;
% midiInputID = 0; % Change this to the appropriate MIDI device ID

midiInputID = availableDevices.input(1).ID;

% Creare a midi device
midiIn = mididevice(midiInputID);

% Define the MIDI file name
midiFileName = 'output.mid';

% Define midi matrix
MidiMatrix = zeros(1,6);

tic,
try
    % Define a loop to continuously record MIDI events
    while toc <=10
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
                end
                % Add to the matrix
                MidiMatrix(end+1,[1:4, entryCol]) = [1, midiMessage.Channel,...
                    double(midiMessage.MsgBytes(2)), double(midiMessage.MsgBytes(3)), midiMessage.Timestamp];         
            end
        end

        % Optional: Add a delay to control the rate of recording
        pause(0.1); % Adjust the delay as needed
    end
catch exception
    % Close the MIDI input object and write the MIDI file in case of an error
    release(midiIn);
    MidiMatrix(1,:) = [];
    midiFileStructure = matrix2midi(MidiMatrix);
    if exist('midiFileStructure', 'var')
        writemidi(midiFileStructure, midiFileName);
    end
    rethrow(exception);
end



MidiMatrix(1,:) = [];
midiFileStructure = matrix2midi(MidiMatrix);
if exist('midiFileStructure', 'var')
    writemidi(midiFileStructure, midiFileName);
end






