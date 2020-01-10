clc
clear all;
close all;
I=imread('test_8.png');%your query image%
figure;
[dima dimb col]=size(I);
imshow(I);
title('Original image');
 src=dir('E:\VIT\VIT Study\SEM V\CBIR\Road\Road\evaldataset\*.png');%source directory of your dataset%
%%Now we will be taking out all the major features from the query image to
%%store it in an final image matrix%
 
 J=rgb2gray(I);

figure,imshow(J);
title('grayscale image');

K=imadjust(J,[0.5 0.9],[]); 

figure;
imshow(K);
level = graythresh(K);  
I=im2bw(K,level);     
%I=imread('test_3.png');
I = im2bw(I, 0.65);
figure;
imshow(I);
title('Binary image after thresholding');


B = medfilt2(I);
figure,imshow(B);
title('median filtered image');

im = bwareaopen(B,10000);

figure,imshow(im);
title('removing connected components(pixel <6)');

BW = bwmorph(im,'remove');
figure,imshow(BW);
title('morphological filtering');

BW1 = edge(BW,'sobel');
figure,imshow(BW1);
title('edge detection(sobel)');
diff_vecquery=[];
diff=[];
diff_vecquery=[BW1];
H = vision.AlphaBlender;
J = im2single(J);
BW1 = im2single(BW1);
Y = step(H,J,BW1);
figure,imshow(Y)
title('overlay on grayscale image');
%Creating feature vector of all images in the dataset%
for i=1:21
    data=imread(strcat('E:\VIT\VIT Study\SEM V\CBIR\Road\Road\evaldataset\',src(i).name));
   
    data=imresize(data,[dima dimb]);
    im=rgb2gray(data);
    K=imadjust(im,[0.5 0.9],[]); 
    level = graythresh(K);
    I=im2bw(K,level);
    I = im2bw(I, 0.65);
    B = medfilt2(I);
    iq = bwareaopen(B,10000);
    BW = bwmorph(iq,'remove');
    BW1 = edge(BW,'sobel');
    dec_vec=[BW1];
    
    k=dec_vec==diff_vecquery;
    iwant=sum(k(:));
    perc=iwant/(dima*dimb)*100;
    diff(i)=[perc];
end
sorted=sort(diff,'descend');
figure;
%Taking the difference from the original query image and then displaying
%top 8 similar images%
for i=1:8
    x=sorted(i);
    for j=1:21
        if(x==diff(j))
            data=imread(strcat('E:\VIT\VIT Study\SEM V\CBIR\Road\Road\evaldataset\',src(j).name));
      
            subplot(4,2,i),imshow(data);
            title(i);
        end
    end
    
    
end