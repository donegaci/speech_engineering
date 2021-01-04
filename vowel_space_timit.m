close all;
clear;

vowels = ["iy", "ih", "eh", "ae", "ah", "aa", "ao", "er", "uh", "uw"];

speaker_path = "../TIMIT_database/TIMIT/TRAIN/DR7";
target_samples=20;
buffer = 4000; % 100 ms buffer before and after each vowel

% Returns all male phonetic transcriptions
male_transcripts = dir(speaker_path + "/M*/*.PHN");

F1_mean = zeros(target_samples, length(vowels));
F2_mean = zeros(target_samples, length(vowels));

for i = 1: length(vowels)
    vowel = vowels(i);
    disp(vowel)
    samples_found=0;
    k = 1;
    % while we haven't found target num of vowel samples yet 
    % and we haven't searched in through every file yet
    while(samples_found < target_samples && k <=length(male_transcripts))
        % Store the name of the file
        filename = append(male_transcripts(k).folder, '/', male_transcripts(k).name);
        fid = fopen(filename);
        % Execute till EOF has been reached
        while(~feof(fid))
            % Read the file line-by-line and store the content 
            contentOfFile = fgetl(fid); 
            % Search for the vowel in contentOfFile
            found = strfind(contentOfFile, vowel); 
            if ~isempty(found)
                disp(filename);
                disp(samples_found);
                disp(contentOfFile);

                % split the line by whitespace which will retrun
                % start_t, end_t and vowel
                split_file =  split(contentOfFile);
                start_t = str2num(split_file{1,1});
                end_t = str2num(split_file{2,1});
                % if the duration of the vowel is less than 640 samples (80 ms)
                % skip it because it's too short
                if end_t - start_t < 640
                    break;
                end
                samples_found = samples_found +1;
                [path, name, ext] = fileparts(filename);
                [x, fs] = audioread(append(path,'/',name,".WAV"));
                [F1, F2, F3, F4, Voice] = mb_ftracker(x,fs);
                F1_mean(samples_found,i) = mean(F1(start_t/2 : end_t/2));
                F2_mean(samples_found,i) = mean(F2(start_t/2 : end_t/2));

                close all;
                break;
                
            end
            
        end
        fclose(fid);
        k = k+1;
    end
    
end
save('timit_formants.mat', 'F1_mean', 'F2_mean')
