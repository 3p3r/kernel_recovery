% Copyright 2016 - Sepehr Laal
% -
% THIS CODE IS PROVIDED AS IS WITH ABSOLUTELY NO WARRANTIES AND
% RESPONSIBILITIES AND ONLY FOR EDUCATIONAL PURPOSES.
% -
% YOU ARE NOT ALLOWED TO REUSE THIS CODE UNLESS YOU HAVE A WRITTEN
% PERMISSION FROM ME (SEPEHR LAAL).

clc
clear all
close all

% [14,14] sample_center is good for data set 5.
% [7 ,14] sample_center is good for data set 6.
% all others work with [5,5]

data_set            = 5;
before_filter       = im2double(imread(sprintf('data/%d/before.tif', data_set)));
after_filter        = im2double(imread(sprintf('data/%d/after.tif', data_set)));
kernel_size         = 5; % must be odd (e.g 5 for a 5x5 kernel)
unknowns_needed     = kernel_size^2 + 1; % +1 for scalar offset
offsets             = [];
kernels             = [];
estimated_offset    = 0;
estimated_kernel    = zeros(kernel_size,kernel_size);

for x=5:size(before_filter,1)-5
for y=5:size(before_filter,2)-5
for channel = 1:3 % three color channels: R,G, and B

    fprintf('Processing pixel at %d,%d\n', x, y);
    sample_center       = [x,y]; % x and y of the center pixel
    sample_offset       = kernel_size - 1;
    input_matrices      = zeros(kernel_size, kernel_size, unknowns_needed);
    output_colors       = zeros(1, unknowns_needed);
    unknowns_counted    = 0;
    faulty_input        = false;

    for counter_row = 0:kernel_size
        for counter_col = 0:kernel_size - 1
            start_y = sample_center(2) - sample_offset + counter_row;
            start_x = sample_center(1) - sample_offset + counter_col;
            end_y = start_y + kernel_size - 1;
            end_x = start_x + kernel_size - 1;

            input_matrices(:,:,unknowns_counted+1) = before_filter(start_y:end_y, start_x:end_x, channel);
            output_colors(unknowns_counted+1) = after_filter(start_y + floor(kernel_size/2),start_x + floor(kernel_size/2), channel);

            unknowns_counted = unknowns_counted + 1;
            if unknowns_counted == unknowns_needed
               break
            end
        end
    end

    output_colors = output_colors.';
    coefficients = zeros(unknowns_needed,unknowns_needed);
    
    black_output_pixels = sum(histc(output_colors, 0));
    white_output_pixels = sum(histc(output_colors, 1));
    
    if black_output_pixels > 0 || white_output_pixels > 0
        warning('Output colors contain black or white. Channel: %d.', channel);
        faulty_input = true;
    end
    
    for input_count = 1:unknowns_needed
        coefficients(input_count,1:unknowns_needed-1) = reshape(input_matrices(:,:,input_count).',[],1);
        coefficients(input_count,unknowns_needed) = 1;
    end
    
    if cond(coefficients)>1.0e5
        warning('Input colors are singular. Channel: %d.', channel);
        faulty_input = true;
    end
    
    if faulty_input
        continue;
    end

    results = mldivide(coefficients, output_colors);
    kernel = reshape(results(1:unknowns_needed - 1), kernel_size, kernel_size).';
    offset = results(end);

    offsets = [offsets offset];
    kernels = [kernels kernel];

end
end
end

clc

[counts, centers]       = hist(offsets);
[max_val, max_index]    = max(counts);
estimated_offset        = centers(max_index);

for index_row = 1:kernel_size
for index_col = 1:kernel_size
    [counts, centers]       = hist(kernels(index_row, index_col,1));
    [max_val, max_index]    = max(counts);
    estimated_kernel(index_row, index_col) = centers(max_index);
end
end

fprintf('Estimated offset: %.6f\n', estimated_offset);
disp('Estimated kernel:');
disp(estimated_kernel);

img = imfilter(before_filter, estimated_kernel, 'conv');
imshow(img + estimated_offset);
