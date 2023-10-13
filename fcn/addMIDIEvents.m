function midiFileStructure = addMIDIEvents(midiFileStructure, trackIndex, deltaTime, status, data)
    % Add MIDI events to a track in the MIDI file structure

    % Create a new event structure
    event = struct();
    event.deltaTime = uint32(deltaTime); % Delta time in ticks
    event.status = uint8(status); % Status byte
    event.data = uint8(data); % MIDI event data

    % Check if the track exists or create a new track
    if length(midiFileStructure.tracks) < trackIndex
        midiFileStructure.tracks(trackIndex) = struct();
        midiFileStructure.tracks(trackIndex).type = 'MTrk'; % Track chunk type
        midiFileStructure.tracks(trackIndex).data = uint8([]); % Initialize track data
    end

    % Append the event to the track's data
    midiFileStructure.tracks(trackIndex).data = [midiFileStructure.tracks(trackIndex).data, ...
                                                 encodeDeltaTime(event.deltaTime), ...
                                                 event.status, ...
                                                 event.data];

    % Optionally, you can add more properties or fields to the event structure

    % Update the current time in the MIDI file structure
%     midiFileStructure.currentTime = midiFileStructure.currentTime + deltaTime;
end