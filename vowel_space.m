clear;
close all;

words = ["beet", "bit", "bet", "bat", "but", "hot", "bought", "bird", ...
    "foot", "boot"];
num_recordings = 20;


F1_mean = zeros(num_recordings, length(words));
F2_mean = zeros(num_recordings, length(words));

% loop through directoy for each word
for i = 1:length(words)
    word = words(i);
    audio_dir = 'audio/' + word + '/';
    % this is a struct with all wav files in directory
    audio_files = dir(append(audio_dir,'*.wav'));
   
    % loop through .wav files for that word
    for j = 1:length(audio_files)

        file = audio_files(j).name;
        full_path = append(audio_dir, file);

        % This trims the audio file and removes silence
        % Code by Theodoros Giannakopoulos from MatLab file exchange
        [x_speech,fs_speech] = detectVoiced(convertStringsToChars(full_path));

        x = x_speech{1,1};
        fs = fs_speech;
        figure()
        t=(0:length(x)-1)/fs;
        plot(t, x);
        title(full_path);
        ylim([-0.15 0.15])
        xlabel('Time (s)');
        ylabel('Amplitude');

        % Perfrom formant estimation
        [F1, F2, F3, F4, Voice] = mb_ftracker(x,fs);

        % find index where voicing begins and ends
        first = find(Voice, 1);
        last = find(~Voice(first:end), 1);
        
        % if voiced segment is too short, it's probabbly wrong
        count=0;
        idx = 0;
        while (last < 500 && count < 5)
            idx = idx + first + last;
            first = find(Voice(idx:end), 1);
            last = find(~Voice((idx+first):end), 1);
            count = count+1;
        end
        
        % If no suitable long voiced segment was found, skip
        if count >=5
           F1_mean(j,i) = NaN;
           F2_mean(j,i) = NaN;
           continue
        end
        
        first = first + idx;
        last = first + last;
        
        % buffer of 100 samples at start and end
        F1 = F1(first+100: last-100); 
        F2 = F2(first+100: last-100);

        F1_mean(j,i) = mean(F1);
        F2_mean(j,i) = mean(F2);

        % wait for key bress to continue
        pause;
        close all
    end

    fprintf('F1 = %s\n', mean(F1_mean, 'omitnan'))
    fprintf('F2 = %s\n', mean(F2_mean,'omitnan'))
    break
end

save('formants.mat', 'F1_mean', 'F2_mean')