
close all;
clear;

% parameter settings
  ps = parameters_setting();

  ps.alpha0 =0.01; % the weight of the regularization term
  ps.mu = 20; 
  ps.lambda = 1; 
  ps.pyramid_factor = 0.5;
  ps.warps = 5; % the numbers of warps per level
  ps.max_its = 5; % the number of equation iterations per warp
 
show_flow =1; % 1 = display the flow, 0 = do not show
h = figure('Name', 'Optical flow');

I1 = double(imread('data/frame10.png'))/255;
I2 = double(imread('data/frame11.png'))/255;
floPath = 'data/flow10.flo';

% call main function
tic
[flow] = coarse_to_fine(I1, I2, ps, show_flow, h);
toc
u = flow(:, :, 1);
v = flow(:, :, 2);
% evalutate the estimated flow
% read the ground-truth flow
realFlow = readFlowFile(floPath);
tu = realFlow(:, :, 1);
tv = realFlow(:, :, 2);
% compute the mean end-point error (mepe) and the mean angular error (mang)
UNKNOWN_FLOW_THRESH = 1e9;
[mang, mepe] = flowError(tu, tv, u, v, ...
   0, 0.0, UNKNOWN_FLOW_THRESH);
disp(['Mean end-point error: ', num2str(mepe)]);
disp(['Mean angular error: ', num2str(mang)]);
%display ground truth
flowImg = uint8(ShowFlow(realFlow));
figure; imshow(flowImg);
% display the computed flow
flowImg = uint8(ShowFlow(flow));
figure; imshow(flowImg);
