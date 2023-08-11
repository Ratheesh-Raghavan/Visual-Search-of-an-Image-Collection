%% cvpr_visualsearch_loop.m
%%
%% This module is a modified version of cvpr_visualsearch module, tailored to 
%% search in loop, to serve for extracting the Precision-Recall statistics for all the
%% classes of images in the dataset.

close all;
clear all;

%% Specify the "METHOD" used to calculate the distance.
% DIST_METHOD = 'EUCLIDEAN';
DIST_METHOD = 'LEVELXXX1';
% DIST_METHOD = 'MAHALANOB';

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/MSRC_ObjCategImageDatabase_v2';

%% Folder that holds the results...
DESCRIPTOR_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/descriptors';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
% DESCRIPTOR_SUBFOLDER='globalRGBhistograms';
% DESCRIPTOR_SUBFOLDER='gridRGBhistograms';
% DESCRIPTOR_SUBFOLDER='gridEOhistograms';
DESCRIPTOR_SUBFOLDER='gridRGBEOhistograms';

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ALLCLASS=[];
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    if fname(2) == '_'
        imgclass = str2double(fname(1));
    else
        imgclass = str2double(fname(1:2));
    end
    ALLCLASS=[ALLCLASS ; imgclass];
    ctr=ctr+1;
end

%% 2) loop for each class, select one image descriptor from each class and search, 
%%    calculate Average Precision for each search, save the results for computing Mean Average PR at the end of loop.
%%    Build confusion matrix.
NIMG=size(ALLFEAT,1);           % number of images in collection
class_counts = hist(ALLCLASS,20);
NCLASS = size(class_counts,2);
class_starting_index = [301;352;382;412;442;472;502;532;562;1;33;63;97;127;157;181;211;241;271;331]; 

% classlabels = 'Farmlands','Trees','Buildings','Aeroplanes','Cows',
%               'HumanFaces','Cars','Bicycles','Sheep','Flowers',
%               'SignBoards','Birds','Books','Chairs','Cats',
%               'Dogs','Streets','WaterBodies','People','Shores'};
% classlabels = categorical(classlabels);

confusion_matrix = zeros(NCLASS);
allclass_average_prec = [];

for classnumber = 1:NCLASS % loop for each class
    % select a random image from the class
    % queryimg=class_starting_index(classnumber) + floor(rand()*class_counts(classnumber));    % index of a random image
    queryimg=class_starting_index(classnumber);
    % disp(queryimg);
    dst=[];
    % compare the query image with each image in the dataset, and compute distance
    for i=1:NIMG
        candidate=ALLFEAT(i,:);
        query=ALLFEAT(queryimg,:);
        if DIST_METHOD == 'EUCLIDEAN'
           thedst=cvpr_euclideanCompare(query,candidate);
        end
        if DIST_METHOD == 'LEVELXXX1'
           x=query - candidate;
           x=abs(x);
           thedst=sum(x)
        end
        dst=[dst ; [thedst i]];
    end
    dst=sortrows(dst,1);  % sort the results
    
    % Compute Precision-Recall Statistics and Confusion Matrix 
    precision=[];
    recall=[];
    match_count = 0;
    cumulative_prec = 0; % for calculating Average Precision
    for i=1:size(dst,1)
        ranked_img_class = ALLCLASS(dst(i,2),:);
        % disp(ranked_img_class);
        if ranked_img_class == classnumber
           match_count = match_count+1;
        end
        updated_precision = match_count/i;
        updated_recall = match_count/class_counts(classnumber);
        precision = [precision ; updated_precision];
        recall = [recall ; updated_recall];
        if ranked_img_class == classnumber
           cumulative_prec = cumulative_prec + updated_precision;
           % disp(cumulative_prec);
        end
    end
    average_precision = cumulative_prec/class_counts(classnumber);
    allclass_average_prec = [allclass_average_prec; average_precision];
    
    % Compute Confusion Matrix 
    SHOW=10; % Show top 20 results
    dst=dst(1:SHOW,:);
    for i=1:size(dst,1)
        ranked_img_class = ALLCLASS(dst(i,2),:);
        if ranked_img_class == classnumber
           confusion_matrix(classnumber,classnumber) = confusion_matrix(classnumber,classnumber) +1;
        else
           confusion_matrix(classnumber,ranked_img_class) = confusion_matrix(classnumber,ranked_img_class) +1;
        end        
    end
end
disp("Average Precision for the image classes");
disp(allclass_average_prec);
MAP = sum(allclass_average_prec)/NCLASS;
disp("Mean Average Precision");
disp(MAP);

confusionchart(confusion_matrix);
