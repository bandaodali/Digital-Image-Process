% function [ output_args ] = DealwithBinary( input_args )
%DEALWITHBINARY 此处显示有关此函数的摘要
% a. do ccl and count size of each poins
% b. remove noise <30 and >200
% c. record the start and end point of a component
% d. use 2 points to calculate △x△y value correspond a line
% e. Go through 1D array, if one label is 0 means parent then find its start and end points to calculate the centre
%     and then go up and down to check if there are other lines(about 3 times wide of line and then find if there is a line 
%     if found a line label it found and count+1
% else to find other side or go to the 1D-arraylist to find next 0-value label until end

Ixx = imread('X.png');
Iyy = imread('Y.png');
s = size(Ixx);
Ix = zeros(s(1),s(2));
Iy = zeros(s(1),s(2));
for i = 1 : s(1)
    for j = 1 : s(2)
        if Ixx(i,j,1) == 255
            Ix(i,j) = 255;
        end
        if Iyy(i,j,1) == 255
            Iy(i,j) = 255;
        end
    end
end
IX = zeros(s(1)+2,s(2)+2);
IY = zeros(s(1)+2,s(2)+2);
label_parentx = zeros(1,10000);
label_parenty = zeros(1,10000);
for i = 1 : 10000
    label_parentx(i) = -1;
    label_parenty(i) = -1;
end

Labelx = zeros(s(1)+2,s(2)+2);
Labely = zeros(s(1)+2,s(2)+2);

labelnumx = 1;
labelnumy = 1;
% CCL 1st
for i = 2 : s(1)+1
    for j = 2 : s(2)+1
        IX(i,j) = Ix(i-1,j-1);
        IY(i,j) = Iy(i-1,j-1);
        if IX(i,j) == 255
            if Labelx(i-1,j) ~= 0
                Labelx(i,j) = Labelx(i-1,j);             
            else
                if Labelx(i-1,j+1) ~= 0 
                    if Labelx(i-1,j-1) ~= 0
                        Labelx(i,j) =Labelx(i-1,j+1);
%                         Union(Labelx(i+1,j-1),Labelx(i-1,j-1),label_parentx);
                        jx1 = Labelx(i-1,j+1);
                        jx1_= jx1;
                        while label_parentx(jx1_)~= 0 && label_parentx(jx1_)~= -1
                            jx1_ = label_parentx(jx1_);
                        end                        
                        jx2 = Labelx(i-1,j-1);
                        jx2_= jx2;
                        while label_parentx(jx2_)~= 0 && label_parentx(jx2_)~= -1
                            jx2_ = label_parentx(jx2_);
                        end
                        if jx2_~= jx1_
                            label_parentx(jx2_) = jx1_;
                        end
                    else
                        if Labelx(i,j-1) ~= 0
                            Labelx(i,j) = Labelx(i-1,j+1);
%                             Union(Labelx(i-1,j),Labelx(i-1,j+1),label_parentx);
                            jx1 = Labelx(i-1,j+1);
                            jx1_= jx1;
                            while label_parentx(jx1_)~= 0 && label_parentx(jx1_)~= -1
                                jx1_ = label_parentx(jx1_);
                            end                            
                            jx2 = Labelx(i,j-1);
                            jx2_= jx2;
                            while label_parentx(jx2_)~= 0 && label_parentx(jx2_)~= -1
                                 jx2_ = label_parentx(jx2_);
                            end
                            if jx2_ ~= jx1_
                            label_parentx(jx2_) = jx1_;
                            end
                        
                        else
                            Labelx(i,j) = Labelx(i-1,j+1);
                        end
                    end
                else
                    if Labelx(i-1,j-1) ~= 0
                        Labelx(i,j) = Labelx(i-1,j-1);
                    else
                        if Labelx(i,j-1) ~= 0
                            Labelx(i,j) = Labelx(i,j-1);
                        else
                            Labelx(i,j) = labelnumx;
                            label_parentx(labelnumx) = 0;
                            labelnumx = labelnumx + 1 ; 
                        end
                    end
                end
            end
        end
        if IY(i,j) == 255
            if Labely(i-1,j) ~= 0
                Labely(i,j) = Labely(i-1,j);             
            else
                if Labely(i-1,j+1) ~= 0 
                    if Labely(i-1,j-1) ~= 0
                        Labely(i,j) =Labely(i-1,j+1);
%                         Union(Labely(i-1,j-1),Labely(i-1,j+1),label_parenty);
                        jy1 = Labely(i-1,j+1);
                        jy1_= jy1;
                        while label_parenty(jy1_)~= 0 && label_parenty(jy1_)~= -1
                            jy1_ = label_parenty(jy1_);
                        end                        
                        jy2 = Labely(i-1,j-1);
                        jy2_= jy2;
                        while label_parenty(jy2_)~= 0 && label_parenty(jy2_)~= -1
                            jy2_ = label_parenty(jy2_);
                        end 
                        if jy2_~= jy1_
                            label_parenty(jy2_) = jy1_;
                        end
                        
                    else
                        if Labely(i,j-1) ~= 0
                            Labely(i,j) = Labely(i-1,j+1);
%                             Union(Labely(i,j-1),Labely(i-1,j+1),label_parenty);
                            jy1 = Labely(i-1,j+1);
                            jy1_= jy1;
                            while label_parenty(jy1_)~= 0 && label_parenty(jy1_)~= -1
                                jy1_ = label_parenty(jy1_);
                            end                            
                            jy2 = Labely(i,j-1);
                            jy2_= jy2;
                            while label_parenty(jy2_)~= 0 && label_parenty(jy2_)~= -1
                                 jy2_ = label_parenty(jy2_);
                            end
                            if jy2_ ~= jy1_
                                 label_parenty(jy2_) = jy1_;
                            end
                            
                        else
                            Labely(i,j) = Labely(i-1,j+1);
                        end
                    end
                else
                    if Labely(i-1,j-1) ~= 0
                        Labely(i,j) = Labely(i-1,j-1);
                    else
                        if Labely(i,j-1) ~= 0
                            Labely(i,j) = Labely(i,j-1);
                        else
                            Labely(i,j) = labelnumy;
                            label_parenty(labelnumy) = 0;
                            labelnumy = labelnumy + 1 ; 
                        end
                    end
                end
            end
        end
    end
end

for i = 1 : labelnumx
    jx = i;
    while label_parentx(jx)~= 0 && label_parentx(jx)~= -1
         jx = label_parentx(jx);
    end
    if i~= jx
        label_parentx(i) = jx;
    end
end
for i = 1 : labelnumy
    jy = i;
    while label_parenty(jy )~= 0 && label_parenty(jy )~= -1
         jy = label_parenty(jy);
    end
    if i~= jy
        label_parenty(i) = jy;
    end
end
%CCL 2nd unit label and get size
label_countx = zeros(1,10000);
label_county = zeros(1,10000);

for i = 2 : s(1)+1
    for j = 2 : s(2)+1 
        if Labelx(i,j) ~=0
            index = Labelx(i,j);
            if label_parentx(index)~=0
                Labelx(i,j) = label_parentx(index);
            end
            index = Labelx(i,j);
            label_countx(index) = label_countx(index)+1;
        end
        if Labely(i,j) ~=0
            index = Labely(i,j);
            if label_parenty(index)~=0
                Labely(i,j) = label_parenty(index);
            end
            label_county(index) = label_county(index)+1;
        end
    end
end

% 3rd eliminate noise
for i = 2 : s(1)+1
    for j = 2 : s(2)+1 
        if Labelx(i,j) ~= 0 
            index = Labelx(i,j);
            if label_countx(index)<20 
                Labelx(i,j) = 0;
                Ix(i-1,j-1) = 0;
            end
            if label_countx(index)>200
                Labelx(i,j) = 0;
                Ix(i-1,j-1) = 0;
            end
        end
        if Labely(i,j) ~= 0 
            index = Labely(i,j);
            if  label_county(index)<20
                Labely(i,j) = 0;
                Iy(i-1,j-1) = 0;
            end
            if label_county(index)>200
                Labely(i,j) = 0;
                Iy(i-1,j-1) = 0;
            end
        end
    end
end
output_imagex = uint8(Ix);
output_imagey = uint8(Iy);
figure('NumberTitle', 'off', 'Name', 'RemoveNoiseGx');
imshow(output_imagex);
figure('NumberTitle', 'off', 'Name', 'RemoveNoiseGy');
imshow(output_imagey);

whetherlabelx = zeros(1,labelnumx);
whetherlabely = zeros(1,labelnumy);
recordlabelx  = zeros(10,labelnumx);
recordlabely  = zeros(10,labelnumy); 
% 4.record start and end point of each component
for i = 2 : s(1)+1
    for j = 2 : s(2)+1
        if Labelx(i,j) ~= 0 
            index = Labelx(i,j);
            if whetherlabelx(index) == 0 
                recordlabelx(1,index) = j;
                recordlabelx(2,index) = i;
                whetherlabelx(index) = 1 ;
            end
            if whetherlabelx(index) == 1
                if j<recordlabelx(1,index)
                    recordlabelx(1,index) = j;                    
                end
                if j>recordlabelx(3,index)
                    recordlabelx(3,index) = j;                    
                end
                recordlabelx(4,index) = i;
            end
        end
    end
end
for i = 2 : s(2)+1
    for j = 2 : s(1)+1
        if Labely(j,i) ~= 0 
            index = Labely(j,i);
            if whetherlabely(index) == 0 
                recordlabely(1,index) = j;
                recordlabely(2,index) = i;
                whetherlabely(index) = 1 ;
            end
            if whetherlabely(index) == 1
                if j<recordlabely(1,index)
                    recordlabely(1,index) = j;                    
                end
                if j>recordlabely(3,index)
                    recordlabely(3,index) = j;
                end
                recordlabely(4,index) = i;
            end
        end
    end
end
max_xwidth = 0;
max_xheight = 0;
max_y = 0;
%max size of the mode array
for i = 1 : labelnumx
    dertax = recordlabelx(3,i)-recordlabelx(1,i);
    dertay = recordlabelx(4,i)-recordlabelx(2,i);
    recordlabelx(7,i) = round((recordlabelx(3,i)+recordlabelx(1,i))/2);
    recordlabelx(8,i) = round((recordlabelx(4,i)+recordlabelx(2,i))/2);
    recordlabelx(5,i) = dertax;
    recordlabelx(6,i) = dertay;
    if dertax > max_xwidth 
        max_xwidth = dertax;
    end
    if dertay > max_xheight 
        max_xheight = dertay;
    end
end

for i = 1 : labelnumy
    dertay = recordlabely(3,i)-recordlabely(1,i);
    dertax = recordlabely(4,i)-recordlabely(2,i);
    recordlabely(5,i) = dertay;
    recordlabely(6,i) = dertax;
    recordlabely(7,i) = round((recordlabely(3,i)+recordlabely(1,i))/2);
    recordlabely(8,i) = round((recordlabely(4,i)+recordlabely(2,i))/2);
    if dertay > max_y 
        max_y = dertay;
    end        
end
modex_width = zeros(1,max_xwidth);
modex_height = zeros(1,max_xheight);
modey = zeros(1,max_y);
% get mode wide 
for i = 1:labelnumx
    if recordlabelx(5,i) > 0
        index = recordlabelx(5,i);
        modex_width(index) = modex_width(index)+1;
    end
    if recordlabelx(6,i) > 0
        index = recordlabelx(6,i);
        modex_height(index) = modex_height(index)+1;
    end
end
for i = 1:labelnumy
    if recordlabely(5,i) > 0
        index = recordlabely(5,i);
        modey(index) = modey(index)+1;
    end
end
maxxwidth = 0 ;
maxxheight = 0 ;
maxy = 0;
for i = 1:max_xwidth
    if modex_width(i) > maxxwidth
        maxxwidth = i;
    end
end
for i = 1:max_xheight
    if modex_height(i) > maxxheight
        maxxheight = i;
    end
end
for i = 1:max_y
    if modey(i) > maxy
        maxy = i;
    end
end

 
width = min(maxx,maxy);

% 5.count the size 
% go through with Gx
for i = 2 : s(1)+1
    for j = 2 : s(2)+1
        if Labelx(i,j) ~= 0 
            index = Labelx(i,j);
            if abs(recordlabelx(5,index)) > maxxwidth || recordlabelx(6,index) >1.5*maxxheight || recordlabelx(6,index) <0.5*maxxheight
                Labelx(i,j) = 0;
                Ix(i-1,j-1) = 0;
                whetherlabelx(index) = 0;
            end
        end
        if Labely(i,j) ~= 0 
            index = Labely(i,j);
            if abs(recordlabely(5,index)) > 12 || recordlabely(6,index) >40 || recordlabely(6,index) <20
                Labely(i,j) = 0;
                Iy(i-1,j-1) = 0;
                whetherlabely(index) = 0;
            end
        end
    end
end

output_imagex = uint8(Ix);
output_imagey = uint8(Iy);
figure('NumberTitle', 'off', 'Name', 'CoarseLine_Gx');
imshow(output_imagex);
figure('NumberTitle', 'off', 'Name', 'CoarseLine_Gy');
imshow(output_imagey);

count = 0 ;
countx = 0;
county = 0;
% 6.judge line-like shape is a parking line
for i = 1 : labelnumx
    % go right
    if whetherlabelx(1,i)==1 %judge one label if it is an component of the low noice picture
        if recordlabelx(9,i)==0
            recordlabelx(9,i) = 1; % turn this component checked
            cx = recordlabelx(7,i);
            cy = recordlabelx(8,i);
            countwhite = 0;
            countblack = 0;
%           1. get out from the line part
%           x-right check
            while countblack<25&&cx<s(2)+2
                index = Labelx(cy,cx);
                if index~=0                    
                    if countblack>10 && index ~= i
                        recordlabelx(9,index)= 1;
                        recordlabelx(9,i)= 1;
                        recordlabelx(10,index)= 1;
                        recordlabelx(10,i)= 1;
                    end 
                    countblack = 0;
                    countwhite = countwhite + 1;
                end
                if index==0
                    countwhite = 0;
                    countblack = countblack + 1;
                end
                cx = cx + 1;
            end
            countwhite = 0;
            countblack = 0;
            cx = recordlabelx(7,i);
            cy = recordlabelx(8,i);
%             x-left check
            while countblack<25&&cx>1
                index = Labelx(cy,cx);
                if index~=0
                    if countblack>10 && index ~= i 
                        recordlabelx(9,index)= 1;
                        recordlabelx(9,i)= 1;
                        recordlabelx(10,index)= 1;
                        recordlabelx(10,i)= 1;
                    end 
                    countblack = 0;
                    countwhite = countwhite + 1;
                end
                if index==0
                    countwhite = 0;
                    countblack = countblack + 1;
                end
                cx = cx - 1;
            end
        end
    end
end
% go through with Gy
for i = 1 : labelnumy
    % go down
    if whetherlabely(1,i)==1 %judge one label if it is an component of the low noice picture
        if recordlabely(9,i)==0
            recordlabely(9,i) = 1; % turn this component checked
            cy = recordlabely(7,i);
            cx = recordlabely(8,i);
            countwhite = 0;
            countblack = 0;
%           y-down check
            while countblack<25&&cy<s(1)+2
                index = Labely(cy,cx);
                if index~=0
                    if countblack>10 && index ~= i                         
                        recordlabely(9,index)= 1;
                        recordlabely(9,i)= 1;
                        recordlabely(10,index)= 1;
                        recordlabely(10,i)= 1;
                    end 
                    countblack = 0;
                    countwhite = countwhite + 1;
                end
                if index==0
                    countwhite = 0;
                    countblack = countblack + 1;
                end
                cy = cy + 1;
            end
            countblack = 0;
            cy = recordlabely(7,i);
            cx = recordlabely(8,i);
%             y-up check
            while countblack<25&&cy>0
                index = Labely(cy,cx);
                if index~=0
                    if countblack>10  && index ~= i
                        recordlabely(9,index)= 1;
                        recordlabely(9,i)= 1;
                        recordlabely(10,index)= 1;
                        recordlabely(10,i)= 1;
                    end 
                    countblack = 0;
                    countwhite = countwhite + 1;
                end
                if index==0
                    countwhite = 0;
                    countblack = countblack + 1;
                end
                cy = cy - 1;
            end
        end
    end
end
count = countx+ county;
%filter component is line
for i = 2 : s(1)+1
    for j = 2 : s(2)+1
        if Labelx(i,j) ~= 0 
            index = Labelx(i,j);
            if recordlabelx(10,index) ~=1
                Labelx(i,j) = 0 ;
                Ix(i-1,j-1) = 0;
            end
        end
        if Labely(i,j) ~= 0 
            index = Labely(i,j);
            if recordlabely(10,index) ~=1
                Labelx(i,j) = 0 ;
                Iy(i-1,j-1) = 0;
            end
        end
    end
end
for i = 1 : labelnumy
    if recordlabely(10,i)==1
        county = county+1;
    end
end
for i = 1 : labelnumx
    if recordlabelx(10,i)==1
        countx = countx+1;
    end
end
count = countx + county;
output_imagex = uint8(Ix);
output_imagey = uint8(Iy);
figure('NumberTitle', 'off', 'Name', 'OnlyLineGx');
imshow(output_imagex);
figure('NumberTitle', 'off', 'Name', 'OnlyLineGy');
imshow(output_imagey);
figure('NumberTitle', 'off', 'Name', 'output_imageGx');
Ixx = uint8(Ixx);
imshow(Ixx);
% str = sprintf('d%',count);
% figure('NumberTitle', 'off', 'Name', 'Total count='+str);
figure('NumberTitle', 'off', 'Name', 'output_imageGy');
Iyy = uint8(Iyy);
imshow(Iyy);
figure('NumberTitle', 'off', 'Name', 'Totalcount');
bary = [countx, county, count];
b = bar(bary);
ch = get(b,'children');
set(gca,'XTickLabel',{'countx','county','count'})
