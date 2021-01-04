words = ["beet", "bit", "bet", "bat", "but", "hot", "bought", "bird", ...
    "foot", "boot"];

audio_dir = "./audio/";
if ~(isfolder(audio_dir))
    mkdir(audio_dir)
end 

fs = 16000;
n_bits = 16;
device_id = 2; % external microphone
n_channels = 1;

if ~audiodevinfo(1, device_id, fs, n_bits, n_channels)
    disp("Headset not connected? Try restarting MATLAB")
    return
end

% record at 16000kHz with 16bits and mono channel with device id=2 (headset) 
recorder = audiorecorder(fs, n_bits, n_channels, device_id);

for i = 1:length(words)
    word = words{i};
    save_dir = audio_dir + word;
    if ~(isfolder(save_dir)) 
        mkdir(save_dir)
    end
    
    for k = 1 :20 
        disp(["Say "+  word + " - " + k])
        recordblocking(recorder, 1.5)
        disp('End of Recording')

        y = getaudiodata(recorder);
        out_file = save_dir + "/" + k + ".wav";
        audiowrite(out_file, y, fs)
    end
    pause;
end

