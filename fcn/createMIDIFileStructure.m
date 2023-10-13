function midiFileStructure = createMIDIFileStructure(format, numTracks, division)
    % Create a MIDI file structure with header information

    % Initialize the MIDI file structure
    midiFileStructure = struct();

    % Header Chunk
    midiFileStructure.header = struct();
    midiFileStructure.header.type = 'MThd'; % Header chunk type
    midiFileStructure.header.length = uint32(6); % Header length is always 6
    midiFileStructure.header.format = uint16(format); % Format (0, 1, or 2)
    midiFileStructure.header.numTracks = uint16(numTracks); % Number of tracks
    midiFileStructure.header.division = uint16(division); % Division (ticks per beat)

    % Initialize the tracks field
    midiFileStructure.tracks = struct([]);

    % Optionally, you can add more fields or properties to the structure as needed
end