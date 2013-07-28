function cmap = cie_bluewhitered_cmap2(n, func, dbg)

% -------------------------------------------------------------------------
% Default inputs
if nargin<3 || isempty(dbg)
    dbg = 0; % Whether to output information and figures
end
if nargin<2
    func = []; % function to map from cielab to srgb. (Only used if stored cmap doesn't exist or needs replacing)
end
if nargin<1 || isempty(n)
    n = size(get(gcf,'colormap'),1); % Number of colours in the colormap
end

% -------------------------------------------------------------------------
% Parameters

% CIELCH      [  L*      c    h]
  lchblue   = [ 44.25,  91, 290]; % 289
  lchred    = [ 44.25,  91,  41];
  wp        = [ 99.00,   0,   0];

% -------------------------------------------------------------------------
% CIELab    [  L*   a*   b*]
labblue   = [lchblue(1), lchblue(2)*cosd(lchblue(3)), lchblue(2)*sind(lchblue(3))];
labred    = [lchred(1) ,  lchred(2)*cosd(lchred(3)) ,  lchred(2)*sind(lchred(3)) ];
labwp     = [wp(1)     ,      wp(2)*cosd(wp(3))     ,      wp(2)*sind(wp(3))     ];

neach = ceil(n/2);

L1 = linspace(labblue(1), labwp(1), neach);
a1 = linspace(labblue(2), labwp(2), neach);
b1 = linspace(labblue(3), labwp(3), neach);

L2 = linspace(labwp(1), labred(1), neach);
a2 = linspace(labwp(2), labred(2), neach);
b2 = linspace(labwp(3), labred(3), neach);

Lab1 = [L1' a1' b1'];
Lab2 = [L2' a2' b2'];

switch mod(n,2)
    case 0
        % n is even
        Lab1 = Lab1(1:end-1,:);
        Lab2 = Lab2(2:end  ,:);
    case 1
        % n is odd
        Lab1 = Lab1(1:end-1,:);
%         Lab2 = Lab2;
end

% Convert from Lab to srgb
Lab  = [Lab1;Lab2];
cmap = gd_lab2rgb(Lab,func);

% If dbg, output figures showing colormap construction
if dbg
    g = fetch_cielchab_gamut('srgb');

    ghb = g.lch(g.lch(:,3)==lchblue(3),:);
    ghr = g.lch(g.lch(:,3)==lchred(3),:);

    figure; set(gca,'Color',[.467 .467 .467]); hold on; box on;
    plot(ghb(:,2),ghb(:,1),'b-');
    plot([labwp(2) lchblue(2)],[labwp(1) lchblue(1)],'k-');
    plot(ghr(:,2),ghr(:,1),'r-');
    plot([labwp(2) lchred(2)],[labwp(1) lchred(1)],'ko');


    % Plot the colormap
    img = repmat(cmap,[1 1 20]);
    img = permute(img,[1 3 2]);
    figure;
    imagesc(img);
    axis xy;
end

end