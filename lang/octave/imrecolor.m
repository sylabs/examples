clear all
  
colors = "./leiaNewok.jpg";
input  = "./vader.jpg";
output = "./out.jpg";
ext    = "jpg";

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
colors = imread(colors);
input  = imread(input);

% flatten both images (grayscale)
flat_in = sum(input, 3);
flat_std = sum(colors, 3);

% reshape input image into vector
[rows cols rgb] = size(input);
vect_in = reshape(flat_in, rows*cols, 1);

% sort (and prepare to reverse)
[flat_std, ind_std] = sort(flat_std(:));
[vect_in, ind_in] = sort(vect_in);
tmp = 1:length(vect_in);
unsortInd(ind_in) = tmp;

for ii = 1:rgb
  
  % make colors into "sorted" vector
  this_std = colors(:, :, ii)(:);
  this_std = this_std(ind_std);
  
  % up or downsample pixels to fit input image
  x = 1/length(this_std):1/length(this_std):1;
  x1 = 1/length(vect_in):1/length(vect_in):1;
  this_std = interp1(x, this_std, x1)';
  
  % reverse sort on colors
  this_std = this_std(unsortInd);
  
  % reverse reshape 
  this_std = reshape(this_std, rows, cols);

  % replace with colors color pixels
  input(:,:,ii) = this_std;
  
end

input = uint8(input);

imwrite(input, output, format)
