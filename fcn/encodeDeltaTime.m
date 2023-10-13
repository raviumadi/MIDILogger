function deltaBytes = encodeDeltaTime(deltaTime)
    % Encode delta time using variable-length encoding

    deltaBytes = uint8([]);
    while deltaTime > 0
        byte = mod(deltaTime, 128); % Seven bits at a time
        deltaTime = floor(deltaTime / 128);
        if deltaTime > 0
            byte = byte + 128; % Set the eighth bit if there are more bytes
        end
        deltaBytes = [uint8(byte), deltaBytes];
    end
end