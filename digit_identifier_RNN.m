%Decode a handwritten number using a convolutional neural net
%Need the Deep Learning Toolbox and MATLAB support package for USB webcams

[images,correct]= digitTrain4DArrayData; %Import training data (28x28x1x5000 = 5000 28x28 grayscale images)

%Make the net
trainAgain=input('Would you like to train the network [y or n]? ','s');

while trainAgain~='n' && trainAgain~='y'  % errortrap the input statement
    trainAgain=input('Would you like to train the network again [y or n]? ','s');
end

if strcmpi(trainAgain,'y')==1  %if the user wants to retrain the network
    %Define the layers in the network
    layers = [imageInputLayer([28 28 1]) %input layer, sized for 1 input image
              convolution2dLayer(9,20,'Padding','same')   %1st of 3 convolutional layers, 20 dif 9x9 filters, adding the padding line means dont pad edges with 0 values, keeps final image the same size
              reluLayer %1st of 3 corresponding relu layers
              convolution2dLayer(9,20)
              reluLayer 
              convolution2dLayer(9,20)
              reluLayer
              averagePooling2dLayer(2,'Stride',2) %2x2 pooling layer (mean), decides net comp load, Stride means jump 2 to the right for next pool
              fullyConnectedLayer(10) %feedforward net, 1 Hidden layer w/ 100 nodes, 10 output layer nodes (0-9)
              softmaxLayer
              classificationLayer];
    
    %Set training parameters, 10 epochs, learning rate=0.1
    options=trainingOptions('sgdm','Plots','training-progress','MaxEpochs',10,'InitialLearnRate',0.1,'Shuffle','every-epoch');
    
    %Train the net!
    trainedNet = trainNetwork(images,correct,layers,options);

    save digitnet trainedNet; %Saves trained network
    
    % Test how accurate the net is on classifying the 300th number ('3') in the dataset. Net guess and probablity correct.
    [guess, prob]=classify(trainedNet,images(:,:,:,300));
else
    load digitnet;  % If the user does not want to retrain the network, load and use the previously trained network.
end 

%Use the net
camera = webcam; % Connect to the camera

figure;
while true    %this is a loop that will go on forever unless you break out of it.
    im=snapshot(camera); % Take a picture
    image(im); % Show the picture
    im=rgb2gray(im); %make the image grayscale (that's what the network is expecting)
    im=round(double(im)/255);  % change from 0-255 integer to 0-1 double (increase contrast by using round)
    im=imresize(im,[28 28]); % Resize the picture for the network you trained (it's expecting a 28x28 image)
    label=classify(trainedNet,im); % Classify the picture.  
    title(char(label),'fontsize',18); % Display the number the net thinks it is
    drawnow   %force matlab to immediately display the image and label
end