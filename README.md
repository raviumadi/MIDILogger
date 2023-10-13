Recording your composition in midi format is the most modern way of storing music. The advantages of midi files are too many to count. I am currently working on a project that involves teaching piano to special needs children. We needed a method to evaluate how well the children learn and track their progress. A key parameter is to follow the temporal progression of keystrokes and compare them to the template over time. The midi data fits perfectly for this purpose.

However, there is no in-built function for recording midi files in MATLAB&reg; There is hardware support for midi via Audio Toolbox. One can read midi messages from the instrument and even write messages to the instrument. But, one can not pass the incoming messages to a .mid file. Talk about a gaping hole! If they have not done it in the last 40 years of MIDI's existence, I have little hope that they will include this in the next update, which they implied in their reply to my query.

Meanwhile, I needed a solution. After digging around, I landed upon [Ken Schutte's 14-year-old work](https://kenschutte.com/midi/). It looked good enough for quick modification for passing incoming midi messages to a matrix and tweaking the `matrix2midi()` function a bit to make it work.

Get Ken Schutte's [Matlab-midi](https://github.com/kts/matlab-midi) 

Here are the changes to make in the function `matrix2midi()`

Below the line #88
``` 
[junk,ord] = sort(note_events_ticktime);
```

Add
```
ord(junk==0) = [];
```
This ignores the zeros in noteOn/noteOff columns of the matrix.

Then, uncomment lines #108:109 and comment #111:112. This enables adding noteOff message when the midi files are read in, instead of noteOn with velocity 0. Here is the relevant piece from the function.
```matlab
if (note_events_onoff(ord(j))==1)
            % note on:
            midi.track(i).messages(msgCtr).type = 144;
            midi.track(i).messages(msgCtr).data = [trM(n,3); trM(n,4)];
        else
            %-- note off msg:
            midi.track(i).messages(msgCtr).type = 128;
            midi.track(i).messages(msgCtr).data = [trM(n,3); trM(n,4)];
            %-- note on vel=0:
%             midi.track(i).messages(msgCtr).type = 144;
%             midi.track(i).messages(msgCtr).data = [trM(n,3); 0];
        end
```

You could use `timidity` or any software synthesiser to generate `.wav` files of your composition. 

## User Notes

When you run this script, a figure window pops, from where the keypress commands are read in. Press `s` to start recording, and `x` to stop. The .mid files are generated with `timestamp-username.mid` format and stored in the `rec/` folder. Change the `recpath` in the script if you wish to store the files elsewhere.

## Limitations

In the current version, the control commands are ignored. Please send a pull-request if you would like to take it from here.

Happy Recording!