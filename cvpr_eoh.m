function H=cvpr_eoh(img,Q)
% INPUT: img, an RGB image where pixels have RGB values in range 0-255
% INPUT: Q, the level of quantization of the RGB space e.g. 4
% First, create qimg, an image where RGB are normalised in range 0 to (Q-1)
% We do this by dividing each pixel value by 256 (to give range 0 - just
% under 1) and then multiply this by Q, then drop the decimal point.

% img = double(img)./256;
% img = img(:,:,1).*0.30 + img(:,:,2).*0.59 + img(:,:,3).*0.11;
img = double(rgb2gray(img));
% disp(img);
sobel_xfilter = [-1,0,1;-2,0,2;-1,0,1]; % Sobel filter for horizontal differential
sobel_yfilter = sobel_xfilter'; % Sobel filter for vertical differential
img_xdiff = filter2(sobel_xfilter,img); % perform convolution to find df/dx  
img_ydiff = filter2(sobel_yfilter,img); % perform convolution to find df/dy  

img_mag = sqrt(img_xdiff.^2 + img_ydiff.^2); % compute magnitude
r=size(img_mag,1);
c=size(img_mag,2);
img_mag(1,:) = 0;
img_mag(r,:) = 0;
img_mag(:,1) = 0;
img_mag(:,c) = 0;
img_mag_max = max(max(img_mag));
% disp(img_mag_average_norm);
% img_mag_norm255 = floor((img_mag./img_mag_max).*255); % normalise from 0 to 255
img_mag_norm = img_mag./img_mag_max; % normalise
img_mag_high_ind = ceil(img_mag_norm - .20);
% figure(1);
% imshow(img_mag_high_ind);

img_theta = atan2(img_ydiff,img_xdiff);
% disp(img_theta);
% maxtheta = max(max(img_theta));
% mintheta = min(min(img_theta));
% disp(maxtheta);
% disp(mintheta);
% img_theta_max = max(max(img_theta));
% img_theta_norm = img_theta./img_theta_max;
% figure(2);
% imshow(img_theta_norm);
img_theta_vals=reshape(img_theta,1,size(img_theta,1)*size(img_theta,2));
img_mag_high_ind_vals=reshape(img_mag_high_ind,1,size(img_mag_high_ind,1)*size(img_mag_high_ind,2));
img_theta_vals_sel = [];
for i=1:(size(img_theta_vals,2))
    if img_mag_high_ind_vals(1,i) == 1
            img_theta_vals_sel = [img_theta_vals_sel,img_theta_vals(1,i)];
    end
end
% disp(img_theta_vals_sel);
img_theta_max = max(max(img_theta_vals_sel));
img_theta_vals_sel_norm = img_theta_vals_sel./img_theta_max;
img_theta_quanta_vals = floor(abs(img_theta_vals_sel_norm).*Q);

% disp(img_theta_quanta_vals);
% Q = Q * 2;
% disp(Q);
% img_theta_quanta_vals=reshape(img_theta_quanta,1,size(img_theta_quanta,1)*size(img_theta_quanta,2));
% img_mag_high_ind_vals=reshape(img_mag_high_ind,1,size(img_mag_high_ind,1)*size(img_mag_high_ind,2));
% disp(img_theta_quanta_vals);
% disp(size(img_theta_quanta,2));
% disp(img_mag_high_ind_vals);
% disp(size(img_mag_high_ind,2));

% Now we can use hist to create a histogram of Q^3 bins.
% H = hist(img_theta_quanta_vals,Q);
H = hist(img_theta_quanta_vals,Q);
% H = hist(img_theta_quanta_vals_sel,Q);
% It is convenient to normalise the histogram, so the area under it sum
% to 1.
H = H ./sum(H);
return;