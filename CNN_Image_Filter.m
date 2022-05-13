%Using a CNN to filter an image
pete=imread('http://socsci.uci.edu/~saberi/psych149/project8/images/pete.jpg'); %load image of peter the anteater
fSharp=[0 -1 0   %3x3 filter that will shaprpen the image
       -1 5 -1
       0 -1 0];
fEdge=[-1 -1 -1  %edge detecting filter
       -1  8 -1
       -1 -1 -1];
fBlur=[1 2 1     %3x3 blurring filter
       2 4 2
       1 2 1];
sharp=conv2(pete,fSharp); %convolves image of peter with the sharpening filter
edge=conv2(pete,fEdge); %convolves image of peter with the edge filter
blur=conv2(pete,fBlur); %convolves image of peter with the blurring filter

%SHARP COMPARE
%Compare original Peter to Sharp Peter
figure;
subplot(1,2,1);
imshow(pete);
sharp=sharp./max(max(sharp)); %when you convolve two variables, you could end up with really large numbers.  This line scales back y to a reasonable range.   
sharp=imadjust(sharp);       % Adjust the intensity values of the image to improve contrast when viewing.
subplot(1,2,2);
imshow(mat2gray(sharp));

%EDGE COMPARE
%Compare original Peter to line drawing of Peter image
figure;
subplot(1,2,1);
imshow(pete);
edge=edge./max(max(edge)); %when you convolve two variables, you could end up with really large numbers.  This line scales back y to a reasonable range.   
edge=imadjust(edge);       % Adjust the intensity values of the image to improve contrast when viewing.
subplot(1,2,2);
imshow(mat2gray(edge));

%VERY BLUR COMPARE, poor image quality if subject to sharp or edge filter even twice. 
figure;
subplot(1,2,1);
imshow(pete);
blur=blur./max(max(blur)); %when you convolve two variables, you could end up with really large numbers.  This line scales back y to a reasonable range.   
blur=imadjust(blur);       % Adjust the intensity values of the image to improve contrast when viewing.
subplot(1,2,2);

%Convolve blur many times with the resulting blur to get very blurred image.
s=size(pete); %use to convolve many times and keep the image the same size as the original
for j=1:50   %start the loop, change to change #times it does it
   blur=blur(2:s(1)+1,2:s(2)+1);   %everytime you convolve two matrices, the resultant matrix is just a 
                             %little larger than the original.  This line will crop the size of the 
                             %image to match the original 
   pete=blur;                %Makes it so that the convolving matrice is the newly blurred one
   blur=conv2(pete,fBlur);   % convolves the current pete matrice with the blur filter
end
imshow(mat2gray(blur)); %show blurred out image