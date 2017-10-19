function make_figure(segment,frame,min_depth,max_depth,max_length,output_folder)
tic
csarp_folder = 'Z:\Make_figures\';
plot_option = 1;   %0: Show consecutive parts of the whole scene with defined length (max_length)
                   %1: Show selected part of the scene (from min_along_track to max_along_track)
if nargin==0
    segment = '20160629_03';
    frame = 1;
    min_depth = 0;
    max_depth = 3200;
    max_length = 20;        %Input either a number or "whole" in case you want the whole scene to be shown
    min_along_track = 9.8;   %start of along track to be shown
    max_along_track = 30;   %end of along track to be shown, input either a number or 'end' 
    output_folder = 'Z:\Make_figures\';
end
                   
%----------------------

in_filename = sprintf('%s%s/Data_%s_%03d.mat',csarp_folder,segment,segment,frame);

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
    otherwise
        error('Unknown plot_option! Please try again!')
end

%Load information on ice: depth, density, velocity
ice_parameters = load('pRES001.vel');
ice_parameters = [ice_parameters,zeros(length(ice_parameters),1)]; %add a column: time the radar waves needs to the specified depth and back
ice_parameters(1,4) = 0; %Initialize 
for n=2:length(ice_parameters)
    ice_parameters(n,4) = ice_parameters(n-1,4) + 2/(ice_parameters(n-1,3)*1e6);
end

%Now plot...
for plot_ind = 1:number_plots
            
    rlines = start(plot_ind):stop(plot_ind);
    %Get depth and find limits in vertical direction
    depth = zeros(length(csarp_in.Time),1);
    for n=1:length(csarp_in.Time)
        idx=find((csarp_in.Time(n)-csarp_in.Surface(rlines(1)))>ice_parameters(:,4),1,'last');
        if isempty(idx)
            depth(n) = (csarp_in.Time(n) - csarp_in.Surface(rlines(1)))* 1/sqrt(e0*u0) /2; %e_r of air assumend to be 1
        else
            depth(n) = ice_parameters(idx,1) + ice_parameters(idx,3)*1e6 ...
                *((csarp_in.Time(n) - csarp_in.Surface(rlines(1)))-ice_parameters(idx,4))/2;
        end
    end
    %depth = (csarp_in.Time - csarp_in.Surface(rlines(1)))* 1/sqrt(e0*u0*er_ice) /2;
    depth_start = find(depth<=min_depth,1,'last');
    if (isempty(depth_start))
        depth_start = 1;
    end
    depth_stop = find(depth>max_depth,1,'first');
    if (isempty(depth_stop))
        depth_stop = length(depth);
    end

    rbins = depth_start:depth_stop;
  
    h_fig = figure; clf;

    imagesc(along_track(rlines)-along_track(rlines(1)), ...
        depth(rbins), ...
            lp(csarp_in.Data(rbins,rlines)))
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
end
toc
return;