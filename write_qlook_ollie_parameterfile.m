function write_qlook_ollie_parameterfile
% Write .txt-file containing the parameters of all qlook tasks to be carried out on Ollie
% gRadar.slurm_jobs_path = path to folder where dynamic parameter structs are
% Only writes parameterfiles that do not exist in param_file_path!

param_files = dir([gRadar.slurm_jobs_path,'/qlook_*dynamic*']); %list all available dynamic parameter files
for file_idx = 1:length(param_files)
  load([gRadar.slurm_jobs_path,param_files(file_idx).name],'dynamic_param');
  param = dynamic_param;
  %Check if parameter text file has already been created before
  if ~exist([gRadar.slurm_jobs_path,'qlook_',param.day_seg,'_parameters.txt'],'file')
    % Count frames, breaks, waveforms and channels
    frms = fieldnames(param.frms);
    n_frms = length(frms); %number of frames
    n_breaks = zeros(n_frms,1); %vector containing number of breaks in the respective frame
    for frm_idx = 1:n_frms
      n_breaks(frm_idx,1) = length(fieldnames(param.frms.(frms{frm_idx}).breaks));
    end

    % Write parameters of all qlook task to a .txt file
    file_path =  sprintf('%s/qlook_%s_parameters.txt', gRadar.slurm_jobs_path, param.day_seg);
    fid = fopen(file_path,'w');
    fprintf(fid,'%3s\t %5s\n','frm','break');
    for frm_idx = 1:n_frms
      breaks = fieldnames(param.frms.(frms{frm_idx}).breaks);
      for break_idx = 1:n_breaks(frm_idx,1)
        parms = [param.frms.(frms{frm_idx}).frm_id, param.frms.(frms{frm_idx}).breaks.(breaks{break_idx}).break_id];
        formatSpec = '%03d\t %03d\n';
        fprintf(fid,formatSpec,parms);
      end
    end
  fclose(fid);
  end
end
end
