function [ output_image1,output_image2 ] = sobel_filter( imagestring )
I0 = imread(imagestring);
I1 = double(I0);
Gx =[0.25,0,-0.25;0.5,0,-0.5;0.25,0,-0.25];
Gy =[0.25,0.5,0.25;0,0,0;-0.25,-0.5,-0.25];
%O1 = conv2(I,Gx); 
%O2 = conv2(I,Gy);
s=size(I1);
% /*******grayscale****************/
if(length(s)==2)
O1= zeros(128,128);
O2= zeros(128,128);
I2 = zeros(132,132);
%handle the source image plus2
for i = 1 : s(1)
    for j = 1 : s(2)
        I2(i+2,j+2) = I1(i,j);
    end
end
for i = 1 : s(1)
    for j = 1 : s(2)
        %O1(i,j) = (O1(i,j)+255)/510*255;
        %O2(i,j) = (O2(i,j)+255)/510*255;
        sumX = 0;
        sumY = 0;
        for x= 1 : 3
            for y = 1 : 3
                sumX = sumX + Gx(x,y) * I2(i+x,j+y);
                sumY = sumY + Gy(x,y) * I2(i+x,j+y);
            end
        end
        O1(i,j)=(sumX+255)/510*255;
        O2(i,j)=(sumY+255)/510*255;
    end
end
output_image1 = uint8(O1);
output_image2 = uint8(O2);

figure('NumberTitle', 'off', 'Name', 'output_imageGx');
imshow(output_image1);
figure('NumberTitle', 'off', 'Name', 'output_imageGy');
imshow(output_image2);
figure('NumberTitle', 'off', 'Name', 'output_imageSrc');
imshow(I0);
end
% /****************RGB****************/
if length(s)==3
    O1= zeros(s(1),s(2),3);
    O2= zeros(s(1),s(2),3);
    output_image1 = zeros(s(1),s(2));
    output_image2 = zeros(s(1),s(2));
    I2 = zeros(s(1)+2,s(2)+2,3);
    %initialize
    for k = 1 : s(3)
        for i = 1 : s(1)
            for j = 1 : s(2)
                I2(i+1,j+1,k) = I1(i,j,k);
            end
        end
    end
    for k = 1 : s(3)
        for i = 1 : s(1)
            for j = 1 : s(2)
                sumX = 0 ;
                sumY = 0;
                for x = 1:3
                    for y = 1:3
                        sumX = sumX + Gx(x,y) * I2(i+x-1,j+y-1,k);
                        sumY = sumY + Gy(x,y) * I2(i+x-1,j+y-1,k);
                    end
                end
                if abs(sumX)>20
                    sumX = 255;
                else
                    sumX = 0;
                end
                
                if abs(sumY)>20
                    sumY = 255;
                else
                    sumY = 0;
                end
                O1(i,j,k)= sumX;
                O2(i,j,k)= sumY;
            end
        end
    end
    for i = 1 : s(1)
        for j = 1 : s(2)
            o1=0;
            o2=0;
            for k = 1 : s(3)
                if O1(i,j,k)==255
                    o1=1;
                end
                if O2(i,j,k)==255
                    o2=1;
                end
            end
            if o1==1
                output_image1(i,j)=255;
                for k = 1 : s(3)
                    O1(i,j,k)=255;
                end
            end
            
            if o2==1
                output_image2(i,j)=255;
                for k = 1 : s(3)
                    O2(i,j,k)=255;
                end
            end
        end
    end
    output_image1 = uint8(O1);
    output_image2 = uint8(O2);
    figure('NumberTitle', 'off', 'Name', 'output_imageGx');
    imshow(output_image1);
    imwrite(output_image1,'X.png');
    figure('NumberTitle', 'off', 'Name', 'output_imageGy');
    imshow(output_image2);
    imwrite(output_image2,'Y.png');
    figure('NumberTitle', 'off', 'Name', 'output_imageSrc');
    imshow(I0);
end
end

