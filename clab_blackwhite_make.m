function cmap = clab_blackwhite_make(n, attr, dbg)

% -------------------------------------------------------------------------
% Default inputs
if nargin<3 || isempty(dbg)
    dbg = 0; % Whether to output information and figures
end
if nargin<2
    attr = ''; % Unused
end
if nargin<1 || isempty(n)
    n = size(get(gcf,'colormap'),1); % Number of colours in the colormap
end

% -------------------------------------------------------------------------
use_uplab = false;

L = linspace(0,100,n)';
a = zeros(n,1);
b = zeros(n,1);

Lab = [L a b];

% Needs to be soft conversion because white is outside by 3.8011e-05
cmap = soft_lab2rgb(Lab, use_uplab);

% -------------------------------------------------------------------------
% If dbg mode, display a figure of the outputted colormap
if dbg;
    img = repmat(cmap,[1 1 20]);
    img = permute(img,[1 3 2]);
    figure;
    imagesc(img);
    axis xy;
    title('Output colormap');
    
    plot_labcurve_rgbgamut(Lab, use_uplab);
end

end