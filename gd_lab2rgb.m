function rgb = gd_lab2rgb(Lab, func)
% Utility for converting from CIELab to sRGB
% Gracefully degrading utility
% Uses 'func' if provided ...
% If not, uses ImageProcessingToolbox if available ...
% If not, uses colorspace (which is a function available on FEX) ...
% If not, recommends download of colorspace (using suggestFEXpackage)

if nargin<2
    func = [];
end

if ~isempty(func)
    rgb = func(Lab);
elseif license('checkout','image_toolbox')
    % If using ImageProcessingToolbox
    cform = makecform('lab2srgb');
    rgb = applycform(Lab, cform);
elseif exist('colorspace','file')
    % Use colorspace
%     warning('LABWHEEL:NoIPToolbox:UseColorspace',...
%         ['Could not checkout the Image Processing Toolbox. ' ...
%          'Using colorspace function.']);
    rgb = colorspace('Lab->RGB',Lab);
else
    % Use colorspace
     if exist('suggestFEXpackage','file')
        suggestFEXpackage(28790,...
            ['Since the Image Processing Toolbox is unavailable, '...
             'you may wish to download the colorspace package.\n' ...
             'This package will allow you to convert between different '...
             'colorspaces without the MATLAB toolbox' ...
            ]);
     end
    error('LABWHEEL:NoIPToolbox:NoColorspace',...
        ['Could not checkout the Image Processing Toolbox. ' ...
         'Colorspace function not present either.\n' ...
         'You need one of the two to run this function. ' ...
         ]);
end

end