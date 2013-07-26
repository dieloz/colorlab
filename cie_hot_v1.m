function cmap = cie_hot_v1(n, func)

if nargin<1
    n = size(get(gcf,'colormap'),1);
end
if nargin<2
    func = [];
end

h0 = -15;
h_per_L = 1.2;
maxc = 85.66;

L = linspace(0,100,n);
h = h0 + L*h_per_L;
c = maxc - (L-50).^2 * maxc / 50.^2;

a = c.*cos(h/360*(2*pi));
b = c.*sin(h/360*(2*pi));

Lab = [L' a' b'];

g = fetch_cielchab_gamut();
[TF,P2] = isingamut(Lab,g,'Lab');

Lab(~TF,:) = P2(~TF,:);

sum(TF)/n

if ~isempty(func)
    cmap = func(Lab);
elseif license('checkout','image_toolbox')
    % If using ImageProcessingToolbox
    cform = makecform('lab2srgb');
    cmap = applycform(Lab, cform);
elseif exist('colorspace','file')
    % Use colorspace
    warning('LABWHEEL:NoIPToolbox:UseColorspace',...
        ['Could not checkout the Image Processing Toolbox. ' ...
         'Using colorspace function.']);
    cmap = colorspace('Lab->RGB',Lab);
else
    % Use colorspace
    warning('LABWHEEL:NoIPToolbox:NoColorspace',...
        ['Could not checkout the Image Processing Toolbox. ' ...
         'Colorspace function not present either.\n' ...
         'You need one of the two to run this function.']);
     if exist('suggestFEXpackage','file')
        suggestFEXpackage(28790,'You may wish to download the colorspace package.');
     end
end

end

% Code for determining values to use
function test_code()

g = fetch_cielchab_gamut();

switch method
    case 1
        % Method 1:
        %          [  L  c  h  ]
        % Red max chroma
        maxc_red = [54.5 106 40];
        % Yellow max chroma
        maxc_yel = [95.75 94 106];
        % Picked by using cietools to browse with chroma setting

        h_per_L = (maxc_yel(3)-maxc_red(3)) / (maxc_yel(1)-maxc_red(1));
        h0 = maxc_red(3)-h_per_L*maxc_red(1);

        % % Outcome Programmatically:
        % h0 = -47.2000;
        % h_per_L = 1.6000;
        % maxc = 75.85;

    case 2
        % Method 2: Pick values and play with them
        h0 = 0;
        h_per_L = 1.15;

        % % Outcome manually
        % h0 = 0;
        % h_per_L = 1.15;
        % maxc = 85.66
end

L = 0:100;
h = h0 + L*h_per_L;
h = round(h);

c1 = nan(size(L));
for i=1:length(L)
    tmp = g.lch(g.lch(:,1)==L(i),:);
    [ignore,I] = min(abs(tmp(:,3)-h(i)));
    c1(i) = tmp(I,2);
end

maxc = min(c1(45:55));

c = maxc - (L-50).^2 * maxc / 50.^2;

a = c.*cos(h/360*(2*pi));
b = c.*sin(h/360*(2*pi));

Lab = [L' a' b'];
cform = makecform('lab2srgb');
rgb = applycform(Lab, cform);

clrs = repmat(rgb,[1 1 20]);
clrs = permute(clrs,[1 3 2]);

figure;
hold on;
plot(c1, L, 'g');
plot(c , L, 'k');
title(sprintf('h0 = %f; h/L = %f',h0,h_per_L));

figure;
imagesc(clrs);
axis xy;
title(sprintf('h0 = %f; h/L = %f',h0,h_per_L));

end