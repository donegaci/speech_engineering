close all;
clear;

words = ["beet", "bit", "bet", "bat", "but", "hot", "bought", "bird", ...
    "foot", "boot"];

load formants.mat
my_F1 = mean(F1_mean,'omitnan');
my_F2 = mean(F2_mean,'omitnan');

load timit_formants.mat
F1 = mean(F1_mean);
F2 = mean(F2_mean);

figure()
scatter(my_F1, my_F2, 'b')
labelpoints(my_F1, my_F2, words, 'FontSize', 20)
hold on;
scatter(F1, F2, 'r')
labelpoints(F1, F2, words, 'FontSize', 20)
% title('F_1 vs F_2 for each vowel sound', 'FontSize', 15)
legend('myself', 'TIMIT', 'FontSize', 20)
xlabel('F_1 (Hz)', 'FontSize', 20)
ylabel('F_2 (Hz)', 'FontSize', 20)
grid on;