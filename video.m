%圖片取樣
clear all;


video_file='DemoVideo.mp4';
video=VideoReader(video_file);
frame_number=floor(video.Duration * video.FrameRate);


for i=1:frame_number
    %圖片名稱編碼做補0處理
    if(i<10)
        image_name=strcat('00',num2str(i));
    end 
    if(i>=10 && i<100)
        image_name=strcat('0',num2str(i));
    end
    if(i>=100)
        image_name=strcat('',num2str(i));
    end
    image_name=strcat(image_name,'.tif');
    I=read(video,i);                               
    imwrite(I,image_name,'tif');                  
    I=[];
end

test = imread('091.tif');
%圖片合成影片
clear all;
clc;
srcDic = uigetdir('C:\Users\a0975\MATLAB\Projects\Lesson1\final_project');%輸入存檔的路徑
cd(srcDic);
strong_borderx = [-1 -2 -1;0 0 0;1 2 1];
strong_bordery = [-1 0 1; -2 0 2; -1 0 1];
allnames = struct2cell(dir('*.tif'));
[k,len]=size(allnames);
aviobj = VideoWriter('fianlVideo2.avi');%輸出後的影片名稱
aviobj.FrameRate = 30; %設定1秒幾幀(張圖)
open(aviobj)
grey = zeros(1078,1918);
I2=imnoise(uint8(grey),'gaussian',0.02);
PSF = fspecial('motion',100, 50);
g = imfilter(I2, PSF, 'circular');
for i = 1:len
    
    name = allnames{1,i};
    frame = double(imread(name));
    grey_img = 0.299*frame(:,:,1) + 0.587*frame(:,:,2) + 0.114*frame(:,:,3);
    strong_borderx = [-1 -2 -1;0 0 0;1 2 1];
    strong_bordery = [-1 0 1; -2 0 2; -1 0 1];
    Y = filter2(strong_borderx,grey_img,'valid');
    Z = filter2(strong_bordery,grey_img,'valid');
    strong = grey_img(1:1078,1:1918) + Y + Z;
    invert_img = 255 - strong;
    blur_img = imgaussfilt(invert_img, 150);
    invblur_img = 255 - blur_img;
    target = (strong*256) ./ invblur_img;
    target2 = ((target ./ 255) .^ 0.6) * 255;
    target3 = target2-double(g)*4;
  
    frame = uint8(real(target3));
    writeVideo(aviobj,frame);
end
close(aviobj)