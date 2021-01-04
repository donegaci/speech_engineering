close all; clear

audio_dir = 'audio/bought/1.wav';

[x_speech,fs] = detectVoiced(convertStringsToChars(audio_dir));
x = x_speech{1,1};

% time domain wavefrom
x = x_speech{1,1};
figure()
t=(0:length(x)-1)/fs;
plot(t*1000, x);
xlabel('Time (ms)');
ylabel('Amplitude');

% narrowband spectogram
figure()
v_spgrambw(x, fs, 'BW', 50, 'FMAX', 4500, 'MODE', 'Jcw');

% wideband spectogram
figure()
v_spgrambw(x, fs, 'BW', 200, 'FMAX', 4500, 'MODE', 'Jcw');
