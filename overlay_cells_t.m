function [overlay,color_map] = overlay_cells_t(bf,cells,label_list,alpha)

num_classes = double(max(max(cells)));

if size(cells,1) > size(bf,1)
    pad_bf_1 = size(cells,1) - size(bf,1);
else
    pad_bf_1 = 0;
end

if size(cells,2) > size(bf,2)
    pad_bf_2 = size(cells,2) - size(bf,2);
else
    pad_bf_2 = 0;
end

if size(cells,1) < size(bf,1)
    pad_c_1 = size(bf,1) - size(cells,1);
else
    pad_c_1 = 0;
end

if size(cells,2) < size(bf,2)
    pad_c_2 = size(bf,2) - size(cells,2);
else
    pad_c_2 = 0;
end


bf = padarray(bf,[pad_bf_1,pad_bf_2],'pre');
cells = padarray(cells,[pad_c_1,pad_c_2],'pre');

x = [1,2,3,4,5,6,7,8,9];%,12];
R = [255,255,255,0,0,0,0,127,255];%,255];[255,255,255,127,0,0,0,0,0,127,255]
G = [0,127,255,255,255,127,0,0,0];%,0];[0,127,255,255,255,255,255,127,0,0,0]
B = [0,0,0,0,255,255,255,255,255];%,127];[0,0,0,0,0,127,255,255,255,255,255]

xR = linspace(1,length(R),num_classes);
yR = interp1(x,R,xR);

xG= linspace(1,length(G),num_classes);
yG = interp1(x,G,xG);

xB = linspace(1,length(B),num_classes);
yB = interp1(x,B,xB);

num1 = bf;
num3 = cells;


combo = num1;
combo = reshape(combo,size(num1,1),size(num1,2),size(num1,3));

% baseline = zeros(size(num1,1),size(num1,2),size(num1,3));
baseline = combo.*(uint8(num3==0));

color_map = uint8(zeros(100*num_classes,100,3));
positions = zeros(num_classes,4);
label_str = cell(num_classes,1);

for i=1:num_classes 
    temp = (num3==i);
    temp_R = yR(i);
    temp_G = yG(i);
    temp_B = yB(i);
    temp_cat = uint8(cat(3,temp_R*temp,temp_G*temp,temp_B*temp));
    
%     alpha = 0.3;  

    % Combine the original image and the overlay image with transparency
    compositeImage = uint8(double(combo) .* (1 - alpha)) + uint8(double(temp_cat) .* alpha);

    compositeImageMasked = compositeImage.*uint8(temp);
    
    baseline = baseline + compositeImageMasked;
    
    color_map(100*(i-1)+1:i*100,:,1) = temp_R;
    color_map(100*(i-1)+1:i*100,:,2) = temp_G;
    color_map(100*(i-1)+1:i*100,:,3) = temp_B;
    label_str{i}=label_list{i};%num2str(i);
    positions(i,:) = [30,100*(i-1)+70,1,1];
end

overlay = baseline;
color_map = uint8(color_map);
color_map = insertObjectAnnotation(color_map,"rectangle",positions,label_str,'FontSize',24);

end

