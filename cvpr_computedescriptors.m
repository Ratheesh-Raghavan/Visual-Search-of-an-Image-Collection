%% EEE3032 - Computer Vision and Pattern Recognition (ee3.cvpr)
%%
%% cvpr_computedescriptors.m
%%
%% This code module was originally developed as a skeleton code,
%% provided as part of the coursework assessment. This code will iterate
%% through every image in the MSRCv2 dataset and call one of the below listed 
%% functions, depending on the method used to extract a descriptor from the image.
%% 1) cvpr_globalRGBhist
%% 2) cvpr_computeGrids 
%%    Can be called for RGB histograms as well as for edge oriented histograms
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

%% Specify the "METHOD" used to extract the descriptor from the image.
%% Also specify the parameters if required any for each method.
%% 1) Global Histogram
% DESCR_METHOD = 'GLOBALRGBHIST';
% QUANTIZATION_NO = 4;

%% 2) Grid level RGB histograms
% DESCR_METHOD = 'GRIDXXRGBHIST';
% GRIDFACTOR = 4;
% FUNC = 'RGB';
% QUANTIZATION_NO = 4;

%% 3) Grid level edge orientation histograms 
% DESCR_METHOD = 'GRIDXXXXXXEOH';
% GRIDFACTOR = 4;
% FUNC = 'EOH';
% QUANTIZATION_NO = 4;

%% 4) Grid level RGB and edge orientation histograms (combined)
DESCR_METHOD = 'GRIDXXXRGBEOH';
GRIDFACTOR = 4;
FUNC = 'COM';
QUANTIZATION_NO = 4;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'c:/MATLAB/visiondemo/cwsolution/descriptors';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.

if (DESCR_METHOD == 'GLOBALRGBHIST')
    OUT_SUBFOLDER='globalRGBhistograms';
end

if (DESCR_METHOD == 'GRIDXXRGBHIST')
    OUT_SUBFOLDER='gridRGBhistograms';
end

if (DESCR_METHOD == 'GRIDXXXXXXEOH')
    OUT_SUBFOLDER='gridEOhistograms';
end

if (DESCR_METHOD == 'GRIDXXXRGBEOH')
    OUT_SUBFOLDER='gridRGBEOhistograms';
end

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),fname);
    tic;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=imread(imgfname_full);
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    if (DESCR_METHOD == 'GLOBALRGBHIST')
        F=cvpr_globalRGBhist(img,QUANTIZATION_NO);
    end
    if (DESCR_METHOD == 'GRIDXXRGBHIST')
        F=cvpr_computeGrids(img,GRIDFACTOR,FUNC,QUANTIZATION_NO);
    end
    if (DESCR_METHOD == 'GRIDXXXXXXEOH')
        F=cvpr_computeGrids(img,GRIDFACTOR,FUNC,QUANTIZATION_NO);
    end
    if (DESCR_METHOD == 'GRIDXXXRGBEOH')
        F=cvpr_computeGrids(img,GRIDFACTOR,FUNC,QUANTIZATION_NO);
    end
    save(fout, 'F');
    toc
end
