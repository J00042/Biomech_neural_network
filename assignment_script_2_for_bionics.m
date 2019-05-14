%% Jack Hutton 160141289 ACS340 Biomechatronics assignment 2 script 2 for bionics.
%This script iterates through each data points in a set of EMG data and 
%uses a trained neural network estimate what the gesture is, and control
%a set of servo motors to perform the gesture. 
%ref: http://www.ergovancouver.net/wrist_movements.htm
%Bionics: The main method for the Arduino code needs to be configured to
%feature only 8 servos in the following order:
%0-thumb, 1-pointer, 2-middle, 3-ring, 4-little, 5-wrist up/down, 6-wrist left/right, 7-wrist rotate

%PROBLEM: Latency is far too high, takes ~6-9 seconds to write the
%data to the arduino for a single vector of emg data. Lateny should be a
%few miliseconds at most. 

load('net300');             %load the neural network.
load('emgDataMAV');         %load the preprocessed emg data.
load('gesturePerformed');  %load the preprocessed gesture data.

fclose(instrfind);
s=serial('COM3','BaudRate',9600); %ref: https://uk.mathworks.com/matlabcentral/answers/80833-simple-matlab-arduino-serial-communication      https://uk.mathworks.com/matlabcentral/answers/334355-i-m-trying-to-open-a-serial-port-but-matlab-says-it-s-not-available-what-can-i-do
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
for i=1:1:size(emgDataMAV, 1)
    %use the neural network to estimate the gesture.
    est = net(emg_input(:,i));
    [value, index] = max(est);
    gesture = index - 1;
    
    %write the servos on the arduino to the correct positions. 
    %0-thumb, 1-pointer, 2-middle, 3-ring, 4-little, 5-wrist1, 6-wrist2
    %finger angles: 0 = fully open, 180 = fully closed.
    %wrist positions: 90 = center, 0 = lean back/left, 180 = lean forward/right
    switch(gesture)
        case 0 %rest position
            fwrite(s, 's01805');
            readData=fscanf(s); %reads r
            fwrite(s, 's10455');
            readData=fscanf(s); %reads r
            fwrite(s, 's20455');
            readData=fscanf(s); %reads r
            fwrite(s, 's30455');
            readData=fscanf(s); %reads r
            fwrite(s, 's40455');
            readData=fscanf(s); %reads r
            fwrite(s, 's50905');
            readData=fscanf(s); %reads r
            fwrite(s, 's60905');
            readData=fscanf(s); %reads r
            fwrite(s, 's70905');
            readData=fscanf(s); %reads r
        case 1 %gesture 1 - thumb up
            fwrite(s, 's00005');
            readData=fscanf(s); %reads r
            fwrite(s, 's11805');
            readData=fscanf(s); %reads r
            fwrite(s, 's21805');
            readData=fscanf(s); %reads r
            fwrite(s, 's31805');
            readData=fscanf(s); %reads r
            fwrite(s, 's41805');
            readData=fscanf(s); %reads r
            fwrite(s, 's50905');
            readData=fscanf(s); %reads r
            fwrite(s, 's60905');
            readData=fscanf(s); %reads r
            fwrite(s, 's70905');
            readData=fscanf(s); %reads r
        %case 3 - etc.
        otherwise
    end
    
    
    disp(['i:', num2str(i), ', estimate: ', num2str(gesture), ', actual: ', num2str(gesturePerformed(i)), ', received: ', readData]);
end
disp('end of data');
