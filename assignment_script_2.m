%% Jack Hutton 160141289 ACS340 Biomechatronics assignment 2 script 2.
%This script iterates through each data points in a set of EMG data and 
%uses a trained neural network estimate what the gesture is, and control
%a set of servo motors to perform the gesture. 
%ref: http://www.ergovancouver.net/wrist_movements.htm

%PROBLEM: Latency of up to 1 second. Processing speed is inconsistent.

load('net300');             %load the neural network.
load('emgDataMAV');         %load the preprocessed emg data.
load('gesturePerformed');  %load the preprocessed gesture data.

if ~isempty(instrfind)
     fclose(instrfind);
     delete(instrfind);
end
%fclose(instrfind);
s=serial('COM3','BaudRate',115200); %ref: https://uk.mathworks.com/matlabcentral/answers/80833-simple-matlab-arduino-serial-communication    https://uk.mathworks.com/matlabcentral/answers/334355-i-m-trying-to-open-a-serial-port-but-matlab-says-it-s-not-available-what-can-i-do
fopen(s);
readData=fscanf(s) %reads 'setup'
next = 0;
while ~next %waits until 'loop' is read
    readData = fscanf(s);
    if (size(readData,2) > 1)
        if readData(1,1:4) == 'loop'
            next = 1;
        end
    end
end
readData % prints 'loop'

%Feed the previously pre-processed data into the neural network.
emg_input = mapminmax(emgDataMAV,-1,1)'; % normalise data
for i=1:100:size(emgDataMAV, 1)
    %use the neural network to estimate the gesture.
    est = net(emg_input(:,i));
    [value, index] = max(est);
    gesture = index - 1;
    
    %write the servos on the arduino to the correct positions. 
    %0-thumb, 1-pointer/index, 2-middle, 3-ring, 4-little, 5-wristUD, 6-wristLR
    %finger angles: 0 = fully open (extension), 180 = fully closed (flexion).
    %wrist positions: 90 = center, 0 = lean back/left, 180 = lean forward/right
    %try
    switch(gesture)
        case 0 %rest position
            fwrite(s, '090045045045045090090090', 'sync');
        case 1 %gesture 1 - thumb up
            fwrite(s, '000180180180180090090090', 'sync');
        case 2 %gesture 2 - Extension of index and middle, flexion of the others
            fwrite(s, '180000000180180090090090', 'sync');
        case 3 %gesture 3 - Flexion of ring and little finger, extension of the others
            fwrite(s, '000000000180180090090090', 'sync');
        case 4 %gesture 4 - Thumb opposing base of little finger
            fwrite(s, '180000000000000090090090', 'sync');
        case 5 %gesture 5 - Abduction of all fingers
            fwrite(s, '000000000000000090090090', 'sync');
        case 6 %gesture 6 - Fingers flexed together in fist
            fwrite(s, '180180180180180090090090', 'sync');
        case 7 %gesture 7 - Pointing index
            fwrite(s, '180000180180180090090090', 'sync');
        case 8 %gesture 8 - Abduction of extended fingers
            fwrite(s, '180000000000000090090090', 'sync');
        case 9 %gesture 9 - Wrist supination (axis: middle finger)
            fwrite(s, '180000000000000090090000', 'sync');
        case 10 %gesture 10 - Wrist pronation (axis: middle finger)
            fwrite(s, '000000000000000090090180', 'sync');
        case 11 %gesture 11 - Wrist supination (axis: middle finger)
            fwrite(s, '000000000000000090090000', 'sync');
        case 12 %gesture 12 - Wrist pronation (axis: little finger)
            fwrite(s, '000000000000000090090180', 'sync');
        case 13 %gesture 13 - Wrist flexion
            fwrite(s, '000000000000000180090090', 'sync');
        case 14 %gesture 14 - Wrist extension
            fwrite(s, '000000000000000000090090', 'sync');
        case 15 %gesture 15 - Wrist radial deviation
            fwrite(s, '000000000000000090180090', 'sync');
        case 16 %gesture 16 - Wrist ulnar deviation
            fwrite(s, '180000000000000000090090', 'sync');
        case 17 %gesture 17 - Wrist extension with closed hand
            fwrite(s, '180180180180180000090090', 'sync');
        otherwise
    end
    readData=fscanf(s); %reads r
    %end
    disp(['i:', num2str(i), ', estimate: ', num2str(gesture), ', actual: ', num2str(gesturePerformed(i)), ', received: ', readData]);
    pause(0.3);
end
disp('end of program');

%%------------------------------------------------------------------------------------------------------------------------------

% Feed the previously pre-processed data into the neural network. Works.
% emg_input = mapminmax(emgDataMAV,-1,1)'; % normalise data
% for i=1:20:size(emgDataMAV)
%     est = net(emg_input(:,i));
%     [value, index] = max(est);
%     gesture = index - 1; %round(A*est) - 1;
%     disp(['i:', num2str(i), ', estimate: ', num2str(gesture), ', actual: ', num2str(gesturePerformed(i))]);
% end

%%-------------------------------------------------------------------------------------------------------------------------------

% %Attempt to read the data in and process it live. Does not work. 
% load('net300');             %load the neural network.
% load('S1_A1_E2');           %load data for subject 1.
% emg_filt = zeros(size(emg,1),10);
% emg_avr = zeros(size(emg,1),10);
% emg_input = zeros(size(emg,1),10);
% %find maximum and minimum values for each column (channel) of the emg data
% maximums = zeros(1,10);
% minimums = zeros(1,10);
% for j=1:1:10
%    maximums(j) = max(emg(:,j));
%    minimums(j) = min(emg(:,j));
% end
% %iterate through the data
% for(i=1:1:20) %filter
%     for(j=1:1:10) %filter
%        emg_filt(i,j) = lowPassButter5Hz(emg(i,j)); 
%     end 
% end
% for i=21:1:size(emg,1)
%     %pre-process the data
%     for(j=1:1:10) %filter
%        emg_filt(i,j) = lowPassButter5Hz(emg(i,j)); 
%     end 
%     for(j=1:1:10) %moving average
%        emg_avr(i,j) = mean(emg_filt(i-20:i,j));
%     end 
%     for(j=1:1:10) %map
%        %emg_input(i,j) = (emg(i,j) - minimums(j)) * (1 - (-1)) / (maximums(j) - minimums(j)) + (-1);
%        emg_input(i,j) = (emg_avr(i,j) - min(minimums(j))) * (1 - (-1)) / (max(maximums(j)) - min(minimums(j))) + (-1);
%     end 
%     %deliver to the network
%     est = net(emg_input(i,:)');
%     [value, index] = max(est);
%     gesture = index - 1;
%     disp(['i:', num2str(i), ', estimate: ', num2str(gesture), ', actual: ', num2str(restimulus(i))]);
% end

%%------------------------------------------------------------------------------------------------------------------------------

% load('S1_A1_E2');           %load data for subject 1.
% 
% emg2 = zeros(size(emg,1), 10); %low pass
% emg3 = zeros(size(emg,1), 10); %map
% emg4 = zeros(size(emg,1), 10); %average
% %low pass filter the emg data
% for(i=1:1:10)
%        emg2(:,i) = lowPassButter5Hz(emg(:,i)); 
% end
% %find maximum and minimum values for each column (channel) of the emg data
% maximums = zeros(1,10);
% minimums = zeros(1,10);
% for j=1:1:10
%    maximums(j) = max(emg2(:,j));
%    minimums(j) = min(emg2(:,j));
% end
% %re-map the values, 20-point moving average, input to the network. 
% for i=1:1:20
%     for j=1:1:10
%         %return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
%         emg3(i,j) = (emg2(i,j) - minimums(j)) * (1 - (-1)) / (maximums(j) - minimums(j)) + (-1);
%     end
% end
% for i=21:1:size(emg,1)
%     for j=1:1:10
%         %return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
%         emg3(i,j) = (emg2(i,j) - minimums(j)) * (1 - (-1)) / (maximums(j) - minimums(j)) + (-1);
%         emg4(i,:) = mean(emg3(i-20:i,:));
%     end
%     est = net(emg4(i,:)');
%     %est = net(mapminmax(lowPassButter5Hz(emg(i,:)'),-1,1));
%     [value, index] = max(est);
%     gesture = index - 1; %round(A*est) - 1;
%     disp(['i:', num2str(i), ', estimate: ', num2str(gesture), ', actual: ', num2str(restimulus(i))]);
%     %net(emg4(i,:)')'
% end

%%-------------------------------------------------------------------------------------------------------------------------------

% i=1; k=1; l=1;
% file = strcat('S', num2str(i), '_A1_E2');
% load (['S' num2str(i) '_A1_E2']);
% emgDataMAV = zeros(size(emg,1), 10);
% gesturePerformed = zeros(size(emg,1), 1);
% %apply a 5Hz low pass 2nd order butterworth filter to the data
% for(i=1:1:10)
%    emgDataMAV(:,i) = lowPassButter5Hz(emg(:,i)); 
% end
% % %take a range+1 point moving average for each column of the emg data and
% % assign its gesture to the central value.
% for j=11:1:size(emg, 1)-10
%    emgDataMAV(k,:) = mean(emg(j-10:1:j+10,:)); %contains all 21-point moving averages of the emg data for each participant. 
%    gesturePerformed(l) = restimulus(j);
%    k = k+1;
%    l = l+1;
% end
% emgDataMAV = mapminmax(emgDataMAV,-1,1);
% 
% A=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
% correctness = 0;
% for i=1:1:size(emgDataMAV,1)       %iterate through the data and use the network to estimate the gesture. 1 = rest, 2 = gesture 1, 3 = gesture 2, etc.
%     est = net(emgDataMAV(i,:)');
%     %est = net(mapminmax(lowPassButter5Hz(emg(i,:)'),-1,1));
%     gesture = round(A*est) - 1;
%     %disp(['estimate: ', num2str(gesture), ', actual: ', num2str(gesturePerformed(i))]);
%     if num2str(gesture) == num2str(gesturePerformed(i))
%        correctness = correctness + 1; 
%     end
% end
% disp(['network correct ', num2str(correctness/size(emgDataMAV,1)*100), '% of the time for this subject.']);


% for i=1:27
%     file = strcat('S', num2str(i), '_A1_E2');
%     load (['S' num2str(i) '_A1_E2']);
%     dataSize = size(emg, 1);
%     gestures = zeros(size(emg,1) ,1);
%     for j=1:1:dataSize       %iterate through the data and use the network to estimate the gesture. 1 = rest, 2 = gesture 1, 3 = gesture 2, etc.
%         est = net(mapminmax(lowPassButter5Hz(emg(j,:)'),-1,1));
%         gestures(j) = round(A*est) - 1;
%     end
%     accuracy = 0;
%     for j=1:1:dataSize       %iterate through the data and use the network to estimate the gesture. 1 = rest, 2 = gesture 1, 3 = gesture 2, etc.
%         if restimulus(j) == gestures(j, 1)
%             accuracy = accuracy + 1;
%         end
%     end
%     disp(['network accurate on participant ', num2str(i), ' to ', num2str(accuracy/size(emg,1)*100), '%']);
% end

