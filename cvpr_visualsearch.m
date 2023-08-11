%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_visualsearch.m
%%
%% %% This code module was originally developed as a skeleton code,
%% provided as part of the coursework assessment. This code will load in all
%% descriptors pre-computed (by the function cvpr_computedescriptors) from
%% the images in the MSRCv2 dataset.It will pick a descriptor at random and
%% compare all other descriptors to it - by calling one of the below listed 
%% functions, depending on the method used to calculate the distance (similarity).
%% 1) cvpr_euclideanCompare
%% 2) ...
%% In doing so it will rank the images by similarity to the randomly picked descriptor.
%%
%% Originally coded by:
%% John Collomosse 2010  (J.Collomosse@surrey.ac.uk)
%% Centre for Vision Speech and Signal Processing (CVSSP)
%% University of Surrey, United Kingdom
%%
%% Modified by: 
%% Ratheesh Raghavan
%% MSc Computer Vision, Robotics and Machine Learning

close all;
clear all;

%% Specify the "METHOD" used to calculate the distance.
DIST_METHOD = 'EUCLIDEAN';
% DIST_METHOD = 'LEVELXXX1';
% DIST_METHOD = 'MAHALANOB';

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
%% DESCRIPTOR_SUBFOLDER='globalRGBhistograms';
% DESCRIPTOR_SUBFOLDER='gridRGBhistograms';
DESCRIPTOR_SUBFOLDER='gridEOhistograms';
% DESCRIPTOR_SUBFOLDER='gridRGBEOhistograms';

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    % img=double(imread(imgfname_full))./255;
    % thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           % number of images in collection
% queryimg=floor(rand()*NIMG);    % index of a random image
queryimg=10; % this line is to override the randomely picked index, used for repeated testing for same image. 

%% 3) Compute Eigen Model
e = Eigen_Build(ALLFEAT');
% e.val
e = Eigen_Deflate(e,'keepn',15);
ALLFEATPCA=Eigen_Project(ALLFEAT',e);
ALLFEATPCA = ALLFEATPCA';

%% 4) Compute the distance of image to the query
dst=[];
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);
    % figure(1);
    % imgshow(imread(ALLFILES{queryimg}));
    if DIST_METHOD == 'EUCLIDEAN'
        thedst=cvpr_euclideanCompare(query,candidate);
    end
    if DIST_METHOD == 'LEVELXXX1'
       x=query - candidate;
       x=abs(x);
       thedst=sum(x);
    end
    if DIST_METHOD == 'MAHALANOB'
       candidate=ALLFEATPCA(i,:); % reduced dimensions
       query=ALLFEATPCA(queryimg,:); % reduced dimensions
       thedst=cvpr_euclideanCompare(query,candidate);
    end
    dst=[dst ; [thedst i]];
end
dst=sortrows(dst,1);  % sort the results

%% 5) Visualise the results
%% These may be a little hard to see using imgshow
%% If you have access, try using imshow(outdisplay) or imagesc(outdisplay)

SHOW=10; % Show top 20 results
dst=dst(1:SHOW,:);
outdisplay=[];
for i=1:size(dst,1)
   img=imread(ALLFILES{dst(i,2)});
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   img=img(1:81,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end
figure(2);
% imgshow(outdisplay);
imshow(outdisplay);
axis off;

%% 6) Compute Precision-Recall 
% Identify the category of the queryimg. 
% Use first 2 characters of the filename to identify the image category. 
queryfname=allfiles(queryimg).name;
disp(queryfname);
queryfnamechars = char(queryfname);
query_img_category = queryfnamechars(1:2);
disp(query_img_category);
% Compute the number of images in the query category
query_img_category_count = 0;
for filenum=1:length(allfiles)
    fnamechars=char(allfiles(filenum).name);
    if fnamechars(1:2) == query_img_category
        query_img_category_count = query_img_category_count+1;
    end
end
% Compute precision and recall 
precision=[];
recall=[];
match_count = 0;
for i=1:size(dst,1)
    ranked_img_fname_chars = char(allfiles(dst(i,2)).name);
    ranked_img_category = ranked_img_fname_chars(1:2);
    if ranked_img_category == query_img_category
        match_count = match_count+1;
    end
    updated_precision = match_count/i;
    updated_recall = match_count/query_img_category_count;
    precision = [precision ; updated_precision];
    recall = [recall ; updated_recall];
end
% Plot precision vs recall
figure(3);
plot(recall,precision);
title('Precision-Recall plot for first 10');
xlabel('Recall');
ylabel('Precision');
xlim([0 1]);
ylim([0 1]);