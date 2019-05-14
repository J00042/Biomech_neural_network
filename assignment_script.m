%% Jack Hutton 160141289 ACS340 Biomechatronics assignment 2 script.
%This script loads and formats the EMG data, then trains a neural network.

% clear all
range = 10; %number of data points either side of the central point when performing a moving average.
%% Load the data. 
% %Place all data into two files: emgDataMAV and exercise where emgDataMAV is a range+1 point moving average. 

disp('loading files...');
dataSize = 0; %number of available raw data points
k=1; l=1;

%count the number of datapoints and initialise arrays.
for i=1:27
    file = strcat('S', num2str(i), '_A1_E2');
    load (['S' num2str(i) '_A1_E2']);
    dataSize = dataSize + size(emg, 1);
end
emgDataMAV = zeros(dataSize-(range*2*27),10); %create arrays for 21 point moving average of available data.
gesturePerformed = zeros(dataSize-(range*2*27), 1);
disp(['number of data points: ', num2str(dataSize)]);

%load each file and store the emg MAVs and gesture of the data. Filter and average.
for i=1:27
    file = strcat('S', num2str(i), '_A1_E2');
    load (['S' num2str(i) '_A1_E2']);
    disp(['adding data from file ', num2str(i)]);
    %apply a 5Hz low pass 2nd order butterworth filter to the data
    for(i=1:1:10)
       emg(:,i) = lowPassButter5Hz(emg(:,i)); 
    end
    % %take a range+1 point moving average for each column of the emg data and
    % assign its gesture to the central value.
    for j=11:1:size(emg, 1)-range
       emgDataMAV(k,:) = mean(emg(j-range:1:j+range,:)); %contains all 21-point moving averages of the emg data for each participant. 
       gesturePerformed(l) = restimulus(j); %restimulus is which movement is being performed by the patient at any given sample  refined after the fact to correspond to the actual movement rather than when the movement was supposed to be performed
       k = k+1;
       l = l+1;
    end
end

%% count how many of each type of gesture are in the data. 
disp('counting number of each gesture data point...');
%load('emgData');
%load('exercise');
noOf0s=0; noOf1s=0; noOf2s=0; noOf3s=0; noOf4s=0; noOf5s=0; noOf6s=0;
noOf7s=0; noOf8s=0; noOf9s=0; noOf10s=0; noOf11s=0; noOf12s=0;
noOf13s=0; noOf14s=0; noOf15s=0; noOf16s=0; noOf17s=0;
for i=1:1:size(emgDataMAV, 1)
    switch gesturePerformed(i)
        case 0
            noOf0s = noOf0s + 1;
        case 1
            noOf1s = noOf1s + 1;
        case 2
            noOf2s = noOf2s + 1;
        case 3
            noOf3s = noOf3s + 1;
        case 4
            noOf4s = noOf4s + 1;
        case 5
            noOf5s = noOf5s + 1;
        case 6
            noOf6s = noOf6s + 1;
        case 7
            noOf7s = noOf7s + 1;
        case 8
            noOf8s = noOf8s + 1;
        case 9
            noOf9s = noOf9s + 1;
        case 10
            noOf10s = noOf10s + 1;
        case 11
            noOf11s = noOf11s + 1;
        case 12
            noOf12s = noOf12s + 1;
        case 13
            noOf13s = noOf13s + 1;
        case 14
            noOf14s = noOf14s + 1;
        case 15
            noOf15s = noOf15s + 1;
        case 16
            noOf16s = noOf16s + 1;
        case 17
            noOf17s = noOf17s + 1;
        otherwise
            disp(['other values: ', num2str(gesturePerformed(i))]);
    end
end
disp('done.');

%% sample the emgData and exercise files so that each gesture has exactly
% 5000 instances. Collect 0's from all across the matrix to ensure rest
% positions for different people are recorded. 
disp('sampling 5000 of each data point for each gesture...');
emgDataSampled = zeros(5000*18,10);
gestureSampled = zeros(5000*18, 1);
zeroSampler = 0; %keep track of when to sample a 0.
k=1; %keep track of the index number of the new data sets.
noOf0s=0; noOf1s=0; noOf2s=0; noOf3s=0; noOf4s=0; noOf5s=0; noOf6s=0;
noOf7s=0; noOf8s=0; noOf9s=0; noOf10s=0; noOf11s=0; noOf12s=0;
noOf13s=0; noOf14s=0; noOf15s=0; noOf16s=0; noOf17s=0;
for i=1:1:size(emgDataMAV, 1)
    switch gesturePerformed(i)
        case 0
            if noOf0s < 5000
                if(zeroSampler < 400) %only sample every 400th instance of 0.
                %if(zeroSampler < 750) %only sample every 750th instance of 0.
                    zeroSampler = zeroSampler + 1;
                else
                    zeroSampler = 0;
                    emgDataSampled(k,:) = emgDataMAV(i,:);
                    gestureSampled(k,1) = gesturePerformed(i);
                    k=k+1;
                    noOf0s = noOf0s + 1;
                end
            end
        case 1
            if noOf1s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf1s = noOf1s + 1;
            end
        case 2
            if noOf2s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf2s = noOf2s + 1;
            end
        case 3
            if noOf3s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf3s = noOf3s + 1;
            end
        case 4
            if noOf4s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf4s = noOf4s + 1;
            end
        case 5
            if noOf5s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf5s = noOf5s + 1;
            end
        case 6
            if noOf6s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf6s = noOf6s + 1;
            end
        case 7
            if noOf7s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf7s = noOf7s + 1;
            end
        case 8
            if noOf8s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf8s = noOf8s + 1;
            end
        case 9
            if noOf9s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf9s = noOf9s + 1;
            end
        case 10
            if noOf10s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf10s = noOf10s + 1;
            end
        case 11
            if noOf11s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf11s = noOf11s + 1;
            end
        case 12
            if noOf12s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf12s = noOf12s + 1;
            end
        case 13
            if noOf13s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf13s = noOf13s + 1;
            end
        case 14
            if noOf14s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf14s = noOf14s + 1;
            end
        case 15
            if noOf15s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf15s = noOf15s + 1;
            end
        case 16
            if noOf16s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf16s = noOf16s + 1;
            end
        case 17
            if noOf17s < 5000
                emgDataSampled(k,:) = emgDataMAV(i,:);
                gestureSampled(k,1) = gesturePerformed(i);
                k=k+1;
                noOf17s = noOf17s + 1;
            end
    end
end
disp('done.');

%At this stage emgDataSampled contains MAVs of the emg data with exactly
%5000 instances of each gesture including rest. The values in the rows of 
%gestureSampled indicate which gesture the rows of emgDataSampled is being
%performed. These are essentially the featureDataBalanced and 
%classLabelsBalanced variables from ACS340 lab 3. 

%% set up variables for nnet toolbox
disp('setting up the neural network...');
N = length(gestureSampled);
nc = 18; %number of classes (0-17)
targets = zeros(nc, N);
for i = 1:N
    targets(gestureSampled(i)+1,i) = 1; %row indicates gesture, counting from 0.
end
inputs = mapminmax(emgDataSampled,-1,1)'; % normalise data

%% create and train the neural network
% Create a Pattern Recognition Network
hiddenLayerSize = 300;
net = patternnet(hiddenLayerSize);
% Set up Division of Data for Training, Validation, Testing
%net.divideFcn.divideind;
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
disp('done.');
% Train the Network
disp('training the neural network...');
[net,tr] = train(net,inputs,targets);
% View the Network
view(net)
disp('done.');

%% Test the Network 
disp('showing the results of the neural network.');
outputs = net(inputs);                % implement the network for all inputs 
errors = gsubtract(targets,outputs);  % classification errors 
 
% Plots 
% Uncomment these lines to enable various plots. 
%figure(3), plotperform(tr) 
%figure(4), plottrainstate(tr) 
figure(5), plotconfusion(targets,outputs) 
%figure(6), ploterrhist(errors) 
grid on;

% extract weights from Matlab neural network object 
wi = net.IW{1,1};  % matrix of input-hidden layer weights 
bi = net.b{1};     % vector of input-hidden layer biases 
wh = net.LW{2,1};  % matrix of hidden-output layer weights 
bh = net.b{2};     % vector hidden-output layer biases   
% define an input feature vector to test the network 
j = 12;            % data index for any input feature vector 
xi = inputs(:,j);  % input feature vector for testing the network  
