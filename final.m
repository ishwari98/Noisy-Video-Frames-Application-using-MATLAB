
%Setup
[file path] = uigetfile({'*.mp4',...
    'VIDEO Files (*.mp4)'},...
    '');
fullpathName = strcat(path, file);
workingDir = 'C:';
mkdir(workingDir)
mkdir(workingDir,'images')

%Create VideoReader
Video = VideoReader(fullpathName);

%Create the Image Sequence
ii = 1;

while hasFrame(Video)
   img = readFrame(Video);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end

%Find Image File Names
imageNames = dir(fullfile(workingDir,'images','*.jpg'));
imageNames = {imageNames.name}';

%ADD salt and pepper NOISE
noise = 0.03;
ii = 1;
for ii = 1:length(imageNames)
    im = imread(fullfile(workingDir,'images',imageNames{ii}));
    J = imnoise(im,'salt & pepper', noise);
    fileName = [sprintf('%03dSPNoise',ii) '.jpg'];
    fullName = fullfile(workingDir,'images',fileName);
    imwrite(J , fullName);


end

%Find noise images
SPimgNames = dir(fullfile(workingDir,'images','*SPNoise.jpg'));
SPimgNames = {SPimgNames.name}';

%Create New Video with the Image Sequence
SPoutputVideo = VideoWriter(fullfile('SPoutput.avi'));
SPoutputVideo.FrameRate = Video.FrameRate;
open(outputVideo)

ii = 1;
for ii = 1:length(SPimgNames)
   image = imread(fullfile(workingDir,'images',SPimgNames{ii}));
   writeVideo(SPoutputVideo,image)
end

close(SPoutputVideo);

%ADD gaussian NOISE
noise = 0.03;
ii = 1;
for ii = 1:length(imageNames)
    im = imread(fullfile(workingDir,'images',imageNames{ii}));
    J = imnoise(im,'gaussian', noise);
    fileName = [sprintf('%03dGNoise',ii) '.jpg'];
    fullName = fullfile(workingDir,'images',fileName);
    imwrite(J , fullName);


end

%Find noise images
GimgNames = dir(fullfile(workingDir,'images','*GNoise.jpg'));
GimgNames = {GimgNames.name}';

%Create New Video with the Image Sequence
GoutputVideo = VideoWriter(fullfile('Goutput.avi'));
GoutputVideo.FrameRate = Video.FrameRate;
open(GoutputVideo)

ii = 1;
for ii = 1:length(GimgNames)
   image = imread(fullfile(workingDir,'images',GimgNames{ii}));
   writeVideo(GoutputVideo,image)
end

close(GoutputVideo)



%View the Final Video
shuttleAvi = VideoReader(fullfile('output.avi'));

ii = 1;
while hasFrame(shuttleAvi)
   mov(ii) = im2frame(readFrame(shuttleAvi));
   ii = ii+1;
end

figure 
imshow(mov(1).cdata, 'Border', 'tight')

movie(mov,1,shuttleAvi.FrameRate
implay('output.avi');
