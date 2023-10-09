% Define the MIDI input device ID
availableDevices = mididevinfo;

midiInputID = 1; % Change this to the appropriate MIDI device ID

% Create a MIDI input object
midiIn = mididevice('Input', midiInputID);

% Specify the CSV file name to save the MIDI messages
csvFileName = 'midi_messages.csv';

% Open the CSV file for appending
csvFile = fopen(csvFileName, 'a');

% Define a loop to continuously query and append MIDI messages
try
    while true
        % Receive MIDI messages
        midiMessages = midireceive(midiIn);
        
        % Check if there are new messages
        if ~isempty(midiMessages)
            % Append MIDI messages to the CSV file
            for i = 1:numel(midiMessages)
                % Format the MIDI message for CSV and write to the file
                midiMessage = midiMessages(i);
                csvLine = sprintf('%s,%s,%s,%s\n', ...
                    datestr(now, 'yyyy-mm-dd HH:MM:SS.FFF'), ...
                    num2str(midiMessage.MessageType), ...
                    num2str(midiMessage.Channel), ...
                    num2str(midiMessage.Data));
                fprintf(csvFile, csvLine);
            end
            % Flush the file to ensure data is written immediately
            fflush(csvFile);
        end
        
        % Optional: Add a delay to avoid high CPU usage
        pause(0.1); % Adjust the delay as needed
    end
catch exception
    % Close the MIDI input object and the CSV file in case of an error
    fclose(csvFile);
    release(midiIn);
    rethrow(exception);
end

% Close the MIDI input object and the CSV file when done
fclose(csvFile);
release(midiIn);
