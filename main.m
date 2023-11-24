clear;
close all;
clc;


file = "2022-06-06_10000fps_O300_A80_HFE – kópia.avi";

mov = VideoReader(file);
number_of_frames = mov.NumFrames; 

% Selection of area
show_first_frame = readFrame(mov); %show first frame 
first_frame_to_gray = rgb2gray(show_first_frame); % transform im to gray
[J, rect1] = imcrop(first_frame_to_gray); % choose area for counting (whole droplet) 
cropped_frame_1 = imcrop(first_frame_to_gray, rect1); % crop the chosen area


%Second selection of area
[J, rect2] = imcrop(cropped_frame_1); %crop the image again to select 1 border of droplet
cropped_frame_2 = imcrop(cropped_frame_1, rect2); %crop the image
imshow(cropped_frame_2); %show dropped area


brightness_values1 =zeros(1, number_of_frames); %new list for brightness values
i = 1;

%reading video frame by frame
while hasFrame(mov)
    frame = readFrame(mov); % open frame
    frame = rgb2gray(frame); %convert frame into grayscale 
    frame = imbinarize(frame, "adaptive",'ForegroundPolarity','dark','Sensitivity',0.4); %convert to black and white

    frame = imcrop(frame, rect1); %crop the image according to 1st selection
    frame = imcrop(frame, rect2); %crop the image according to 2nd selection
    
      

    %Counting brightness in selected area 
    brightness = sum(frame, "all" )
    
    %creating list for futher plotting
    brightness_values1(i)=brightness;
    i= i+1

end

%set values on axis x and y 
x_axis = 1:number_of_frames;
y_axis = brightness_values1; 

%plot
figure; 
plot(-y_axis); %invert because droplets are actually black (lowpoints)
xlabel("frame")
ylabel("average intensity")
[pks1,locs1] = findpeaks(-y_axis, x_axis); %plot is inverted, peaks correspond to black color





