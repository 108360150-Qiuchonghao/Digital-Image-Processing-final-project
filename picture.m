clear all;;
frame = double(imread('castle.jpg'));




imshow(uint8(frame));

grey_img = 0.299*frame(:,:,1) + 0.587*frame(:,:,2) + 0.114*frame(:,:,3);

figure;imshow(uint8(grey_img));

strong_borderx = [-1 -2 -1;0 0 0;1 2 1];
strong_bordery = [-1 0 1; -2 0 2; -1 0 1];
Y = filter2(strong_borderx,grey_img,'valid');
figure;imshow(uint8(Y));title("Y");
Z = filter2(strong_bordery,grey_img,'valid');
figure;imshow(uint8(Z));title("Z");
strong = grey_img(1:736,1:1198) + Y + Z;
figure;imshow(uint8(strong));title("strong");

for j = 1:736
    for k = 1:1198
        invert_img(j,k) = 255 - strong(j,k);
    end
end
imshow(uint8(invert_img));

blur_img = imgaussfilt(invert_img, 150);
figure;imshow(uint8(blur_img));

for j = 1:736
    for k = 1:1198
        invblur_img(j,k) = 255 - blur_img(j,k);
    end
end
figure;imshow(uint8(invblur_img));


target = (strong*256) ./ invblur_img;
target2 = ((target ./ 255) .^ 0.6) * 255;
figure;imshow(uint8(real(target2)));


%方法二：用matlab內建的函式生成斜線圖層：
%figure;imshow(uint8(grey_img));
grey = zeros(736,1198);
figure;imshow(uint8(grey));
I2=imnoise(uint8(grey),'gaussian',0.02);
figure;imshow(uint8(I2));title('添加噪音');

PSF = fspecial('motion',100, 50);
g = imfilter(I2, PSF, 'circular');
figure ;imshow(uint8(g));title('运动模糊图');

target3 = target2-double(g)*4;
figure;imshow(uint8(target3));title("fianl");