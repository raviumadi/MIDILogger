function deltaTime = calculateDeltaTime(startTime, currentTime, ticks_per_quarter_note)
    % Calculate delta time in ticks based on the start time and current time

    % Calculate time difference in seconds
    timeDifference = currentTime - startTime;

    % Convert time difference to ticks using ticks per quarter note
    deltaTime = round(timeDifference * ticks_per_quarter_note);
end