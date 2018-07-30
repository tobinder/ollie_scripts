function make_figure(csarp_folder,segment,frame,min_depth,max_depth,max_length,min_along_track,max_along_track,output_folder,plot_option,shift)

if ~exist('shift','var')
  shift = 0;
else
  if (ischar(shift))
  shift=str2num(shift);
  end  
end

if (ischar(frame))
  frame=str2num(frame);
end
if (ischar(min_depth))
  min_depth=str2num(min_depth);
end
if (ischar(max_depth))
  max_depth=str2num(max_depth);
end
if (ischar(max_length))
    if (~strcmp(max_length,'whole'))
        max_length=str2num(max_length);
    end
end
if (ischar(min_along_track))
  min_along_track=str2num(min_along_track);
end
if (ischar(max_along_track))
    if (~strcmp(max_along_track,'end'))
        max_along_track=str2num(max_along_track);
    end
end
if (ischar(plot_option))
  plot_option=str2num(plot_option);
end

in_filename = sprintf('%s%s/Data_%s_%03d.mat',csarp_folder,segment,segment,frame);
%in_filename = sprintf('%s/Data_%s_%03d.mat',csarp_folder,segment,frame);

%Load data and filter
csarp_in = load(in_filename);
csarp_in.Data = filter2(ones([3 3])/9,csarp_in.Data);

%calculate along track distance
along_track = geodetic_to_along_track(csarp_in.Latitude,csarp_in.Longitude)/1e3;

if max_length == 'whole'
    max_length = along_track(1,end);
end

%Get physical constants
physical_constants;

%Get start and stop indices of the parts to be shown
switch plot_option
    case 0
        %determine number of plots
        number_plots = ceil(along_track(1,end)/max_length);
        start = zeros(1,number_plots);
        stop  = zeros(1,number_plots);
        for n=1:number_plots
            start(n) = find(along_track<=(n-1)*max_length,1,'last');
            if (n<number_plots)
                stop(n) = find(along_track>n*max_length,1,'first');
            else
                stop(n) = length(along_track);
            end
        end
    case 1
        number_plots = 1;
        start = find(along_track<=min_along_track,1,'last');
        if max_along_track == 'end'
            stop = length(along_track);
        else
            stop  = find(along_track>max_along_track,1,'first');
        end
    case 2
        number_plots = 1;
        start = 1;
        stop = length(along_track);

        %create coord file
        filename = sprintf('%s%s_%03d_coord.txt',output_folder,segment,frame);
        fid = fopen(filename,'w');
        %fprintf(fid,'%14s %14s %6s %8s\n', 'Lon', 'Lat', 'Shot', 'km');
        fprintf(fid,'%22s\t%8s\t%8s\t%5s\t%5s\t%7s\n', 'Date/Time (GPS)', 'Latitude', 'Longitude', 'km', 'Shot', 'Surface TWT (us)');
        for idx = 1:size(along_track,2)
            %fprintf(fid,'%14.6f %14.6f %6d %8.3f\n', csarp_in.Longitude(idx), csarp_in.Latitude(idx), idx, along_track(idx));
            timestring = datetime(datetime(719529+csarp_in.GPS_time(idx)/(60*60*24),'ConvertFrom','datenum'),'Format','yyyy-MM-dd''T''HH:mm:ss');
            fprintf(fid,'%19s.%02.0f\t%8.6f\t%8.6f\t%5.3f\t%5.0f\t%7.5f\n',timestring,99*(csarp_in.GPS_time(idx)-floor(csarp_in.GPS_time(idx))),csarp_in.Latitude(idx),csarp_in.Longitude(idx),along_track(idx),idx,csarp_in.Surface(idx)*1e6);
        end
        fclose(fid);
    otherwise
        error('Unknown plot_option! Please try again!')
end

%Load information on ice: depth, density, velocity
%ice_parameters = load('pRES001.vel');
%ice_parameters = [ice_parameters,zeros(length(ice_parameters),1)]; %add a column: time the radar waves needs to the specified depth and back
%ice_parameters(1,4) = 0; %Initialize
%for n=2:length(ice_parameters)
%    ice_parameters(n,4) = ice_parameters(n-1,4) + 2/(ice_parameters(n-1,3)*1e6);
%end

if (plot_option<2)
    h_fig = figure;
end

%Now plot...
for plot_ind = 1:number_plots
            
    rlines = start(plot_ind):stop(plot_ind);
    %Get depth and find limits in vertical direction
    %depth = zeros(length(csarp_in.Time),1);
    %for n=1:length(csarp_in.Time)
    %    idx=find((csarp_in.Time(n)-csarp_in.Surface(rlines(1)))>ice_parameters(:,4),1,'last');
    %    if isempty(idx)
    %        depth(n) = (csarp_in.Time(n) - csarp_in.Surface(rlines(1)))* 1/sqrt(e0*u0) /2; %e_r of air assumend to be 1
    %    else
    %        depth(n) = ice_parameters(idx,1) + ice_parameters(idx,3)*1e6 ...
    %            *((csarp_in.Time(n) - csarp_in.Surface(rlines(1)))-ice_parameters(idx,4))/2;
    %    end
    %end
    depth = (csarp_in.Time - csarp_in.Surface(rlines(1)))* 1/sqrt(e0*u0*er_ice) /2;

    depth_start = find(depth<=min_depth,1,'last');
    if (isempty(depth_start))
        depth_start = 1;
    end
    depth_stop = find(depth>max_depth,1,'first');
    if (isempty(depth_stop))
        depth_stop = length(depth);
    end
  
    if (plot_option<2)
        clf;
        imagesc(along_track(rlines)-along_track(rlines(1)), ...
            depth(depth_start:depth_stop), ...
                lp(csarp_in.Data(depth_start:depth_stop,rlines)))
        colormap(1-gray(256))
        h_axes = gca;
        h_colorbar = colorbar;
        set(gca,'XTick',[linspace(0,along_track(rlines(end))-along_track(rlines(1)),5)]);
        %set(gca,'XTick',[0:5:ceil(along_track(rlines(end))-along_track(rlines(1)))]);
        set(gca,'XTickLabel',[round(linspace(along_track(rlines(1)),along_track(rlines(end)),5),2)])
        %set(gca,'XTickLabel',[round(along_track(rlines(1)),2):5:round(along_track(rlines(end)),2)])
        set(get(h_colorbar,'YLabel'),'String','Relative power (dB)')
        xlabel('Along track (km)');
        ylabel(sprintf('Depth (m, e_{r,ice}=%4.2f)',er_ice));
        filename = sprintf('%s%s_%03d_%02d.png',output_folder,segment,frame,plot_ind);
        saveas(h_fig,filename);
    else
        %create times file
        filename = sprintf('%s%s_%03d_times.txt',output_folder,segment,frame);
        fid = fopen(filename,'w');
        fprintf(fid,'%5s\t%7s\n', 'Pixel', 'TWT (us)');
        y_koord=0;

        for idx = depth_start:5:depth_stop
            y_koord=y_koord+1;
            fprintf(fid,'%5.0f\t%7.5f\n',y_koord,csarp_in.Time(idx)*1e6);
        end
        fclose(fid);

        %create full resolution image
        image=zeros(depth_stop-depth_start,size(csarp_in.Data,2));

        max_intensity=max(max(lp(csarp_in.Data(depth_start:depth_stop,1:size(csarp_in.Data,2)))));
        diff_intensity=max_intensity-min(min(lp(csarp_in.Data(depth_start:depth_stop,1:size(csarp_in.Data,2)))));
        
        for y_ind = 1:size(csarp_in.Data,2)
            if (shift) x_correction = floor((csarp_in.Elevation(y_ind)-csarp_in.Elevation(1))/((csarp_in.Time(2)-csarp_in.Time(1))*c/2));
            else x_correction = 0;
            end
            for x_ind = depth_start:depth_stop
                image(x_ind-depth_start+1,y_ind)=(max_intensity-lp(csarp_in.Data(x_ind+x_correction,y_ind)))/diff_intensity;
            end
        end

        filename = sprintf('%s%s_%03d.png',output_folder,segment,frame);
        image_resized = imresize(image,[(depth_stop-depth_start)/5 size(csarp_in.Data,2)]);
        imwrite(image_resized, filename);
    end
end

return;