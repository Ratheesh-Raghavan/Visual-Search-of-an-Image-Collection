function all_grid_hist=cvpr_computeGrids(img,G,FUNC,Q)
%% INPUT: img, an RGB image where pixels have RGB values in range 0-255
%% INPUT: G, the Grid Factor. GxG = number of grids.
%% FUNC: RGB histograms or Edge Orientation histograms.
%% Q: Quantization (can be the quantization for RGB, or angle depending on FUNC).
%% If there exist a reminder of columns or rows, those are also added 
%% to the last stretch of columns or rows to form larger grids.
%%
%% Split the image into grids, and for each grid compute global rgb
%% histograms or edge orientation histograms depening on FUNC.
%% Combine the histograms to form the descriptor for the image.
numofrows  = size(img, 1);
numofcols  = size(img, 2);
GCL = floor(numofcols/G);
GRL = floor(numofrows/G);
% disp(numofcols);
% disp(numofrows);
% disp(GCL);
% disp(GRL);

all_grid_hist = [];
for i = 1:G
    for j = 1:G
        if i == G
            grid_end_row = numofrows;
        else
            grid_end_row = i*GRL;
        end
        if j == G
            grid_end_col = numofcols;
        else
            grid_end_col = j*GCL;
        end
        if FUNC == 'RGB' 
            grid_hist = cvpr_globalRGBhist(img(((i-1)*GRL + 1):grid_end_row,((j-1)*GCL + 1):grid_end_col,:),Q);
        end
        if FUNC == 'EOH'
            grid_hist = cvpr_eoh(img(((i-1)*GRL + 1):grid_end_row,((j-1)*GCL + 1):grid_end_col,:),Q);
        end
        if FUNC == 'COM'
            grid_hist_c = cvpr_globalRGBhist(img(((i-1)*GRL + 1):grid_end_row,((j-1)*GCL + 1):grid_end_col,:),Q);
            grid_hist_e = cvpr_eoh(img(((i-1)*GRL + 1):grid_end_row,((j-1)*GCL + 1):grid_end_col,:),Q);
            grid_hist = [grid_hist_c,grid_hist_e];
        end    
        all_grid_hist = [all_grid_hist, grid_hist];
    end
end

return;