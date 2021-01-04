close all; clear;


% I begin by concatenating 1 example of each vowel into a combined
% recording
words = ["beet", "bit", "bet", "bat", "but", "hot", "bought", "bird", ...
    "foot", "boot"];


combined = zeros(0,1);
% loop through directoy for each word
for i = 1:length(words)
    word = words(i);
    audio_dir = 'audio/' + word + '/';
    full_path = append(audio_dir, "1.wav");
    [x_speech,fs] = detectVoiced(convertStringsToChars(full_path));
    x = x_speech{1,1};
    % concatenate this file to the combined array
    combined = cat(1, combined, x); 
end

% transpose row to column
combined_T = combined';

figure()
t=(0:length(combined)-1)/fs;
plot(t, combined);
xlim([0 max(t)])
xlabel('Time (s)', 'FontSize', 14);
ylabel('Amplitude', 'FontSize', 14);
hold on;

% define window paramaters
wintype = 'rectwin';
winamp =  0.001;
winlength = 200;

% calculate ST zero crossing
zc = zerocross(combined_T, wintype, winamp, winlength);
t_zc = (0:length(zc)-1)/fs;
plot(t_zc, zc, 'Linewidth', 3, 'color' ,'k')
hold on;

% calculate ST energy
en = energy(combined_T, wintype, 0.1, winlength);
plot(t_zc, en, 'LineWidth', 3, 'color', 'r')

% estimate voised speech
voiced = en>zc;
plot(t_zc, voiced*0.2, 'LineWidth', 3, 'color', 'g')

legend('audio wavefrom', 'short time zero-crossings', 'short time energy', ...
    'voiced','FontSize', 20)