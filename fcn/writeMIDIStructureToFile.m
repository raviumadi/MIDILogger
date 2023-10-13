function writeMIDIStructureToFile(midiFileStructure, midiFileName)
    % Write a MIDI file structure to a .mid file

    try
        % Create a MIDI file for writing
        midiFile = fopen(midiFileName, 'wb');

        % Write the header information to the MIDI file
        headerData = [uint8(midiFileStructure.header.type), ...
                      typecast(midiFileStructure.header.length, 'uint8'), ...
                      typecast(midiFileStructure.header.format, 'uint8'), ...
                      typecast(midiFileStructure.header.numTracks, 'uint8'), ...
                      typecast(midiFileStructure.header.division, 'uint8')];
        fwrite(midiFile, headerData);

        % Write the track data to the MIDI file
        for i = 1:length(midiFileStructure.tracks)
            trackData = midiFileStructure.tracks(i).data;
            fwrite(midiFile, uint32(numel(trackData)), 'uint32'); % Track length
            fwrite(midiFile, trackData);
        end

        % Close the MIDI file
        fclose(midiFile);
    catch exception
        rethrow(exception);
    end
end