function write_csarp_ollie_parameterfile
% Write .txt-file containing the parameters of all csarp tasks to be carried out on Ollie
% gRadar.slurm_jobs_path = path to folder where dynamic parameter structs are
% Only writes parameterfiles that do not exist in param_file_path!

param_files = dir([gRadar.slurm_jobs_path,'/csarp_*dynamic*']); %list all available dynamic parameter files
for file_idx = 1:length(param_files)
  load([gRadar.slurm_jobs_path,param_files(file_idx).name],'dynamic_param');
  param = dynamic_param;
  %Check if parameter text file has already been created before
  if ~exist([gRadar.slurm_jobs_path,'csarp_',param.day_seg,'_parameters.txt'],'file')
    % Count frames, chunks, waveforms and channels
    frms = fieldnames(param.frms);
    n_frms = length(frms); %number of frames
    n_chunks = zeros(n_frms,1); %vector containing number of chunks in the respective frame
    for frm_idx = 1:n_frms
      n_chunks(frm_idx,1) = length(fieldnames(param.frms.(frms{frm_idx}).chunks));
    end
    wfs = fieldnames(param.wf); 
    n_wf = length(wfs); %number of waveforms
    n_adc = zeros(n_wf,1); %vector containing number of channels for the respective waveform
    for wf_idx = 1:n_wf
      n_adc(wf_idx,1) = length(param.wf.([wfs{wf_idx}]).channels);
    end

    % Write parameters of all csarp task to a .txt file
    file_path =  sprintf('%s/csarp_%s_parameters.txt', param.slurm_jobs_path, param.day_seg);
    fid = fopen(file_path,'w');
    fprintf(fid,'%3s\t %5s\t %2s\t %3s\n','frm','chunk','wf','adc');
    for frm_idx = 1:n_frms
      chunks = fieldnames(param.frms.(frms{frm_idx}).chunks);
      for chunk_idx = 1:n_chunks(frm_idx,1)
        for wf_idx = 1:n_wf
          for ch_idx = 1:n_adc(wf_idx,1)
            parms = [param.frms.(frms{frm_idx}).frm_id, param.frms.(frms{frm_idx}).chunks.(chunks{chunk_idx}).chunk_id, ...
              param.wf.([wfs{wf_idx}]).wf_id, param.wf.([wfs{wf_idx}]).channels(ch_idx)];
            formatSpec = '%03d\t %03d\t %02d\t %02d\n';
            fprintf(fid,formatSpec,parms);
          end
        end
      end
    end
  fclose(fid);
  end
end
end
