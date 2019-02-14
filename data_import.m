function [app_inter_mat,app_resources,machine_resources,instance_deploy] = data_import_1(data_path)
%% get app interference data
fid = fopen([data_path,'\scheduling_preliminary_app_interference_20180606.csv']);
app_interference = textscan(fid, '%s%s%d','delimiter', ',');
fclose(fid);
% build app_inter sparse matrix
app_inter_mat=sparse(9338,9338);
n_app_inter = length(app_interference{1,1});
for i = 1:n_app_inter
    app1_name = app_interference{1,1}(i);
    app1_name_char = char(app1_name);
    app1_no = str2double(app1_name_char(5:length(app1_name_char))); %get app1_no
    app2_name = app_interference{1,2}(i);
    app2_name_char = char(app2_name);
    app2_no = str2double(app2_name_char(5:length(app2_name_char))); %get app2_no
    app_inter_mat(app1_no,app2_no) = (app_interference{1,3}(i) + 1); 
end

%% get app resources data
fid = fopen([data_path,'\scheduling_preliminary_app_resources_20180606.csv']);
appresources = textscan(fid, '%s%s%s%d%d%d%d','delimiter', ',');
fclose(fid);

appresources{1,2} = cellfun(@(x) strsplit(x,{'|'}),appresources{1,2},'UniformOutput',false);
appresources{1,3} = cellfun(@(x) strsplit(x,{'|'}),appresources{1,3},'UniformOutput',false);
% get CPU MEM data
appresources_CPU_mat = zeros(9338,98);
appresources_MEM_mat = zeros(9338,98);
appresources_CPU = appresources{1,2};
appresources_MEM = appresources{1,3};
for i = 1:9338
    for j = 1: 98
        appresources_CPU_mat(i,j) = str2double(appresources_CPU{i}{j});
        appresources_MEM_mat(i,j) = str2double(appresources_MEM{i}{j});
    end
end

for i = 1:9338
    app_resources(i).ID = appresources{1,1}(i);
    app_resources(i).CPU = appresources_CPU_mat(i,:);
    app_resources(i).MEM = appresources_MEM_mat(i,:);
    app_resources(i).Disk = appresources{1,4}(i);
    app_resources(i).P = appresources{1,5}(i);
    app_resources(i).M = appresources{1,6}(i);
    app_resources(i).PM = appresources{1,7}(i);
    app_resources(i).CPU_max = max(app_resources(i).CPU);
    app_resources(i).MEM_max = max(app_resources(i).MEM);
end

%% get instance deploy data
fid = fopen([data_path,'\scheduling_preliminary_instance_deploy_20180606.csv']);
instancedeploy = textscan(fid, '%s%s%s','delimiter', ',');
fclose(fid);
n_instance = length(instancedeploy{1,1});
instance_deploy = zeros(n_instance, 7); %% ins_ID, App_ID, Mach_ID,Mach_Deploy_ID,CPU,Disk ,Resources
for j = 1:n_instance
    instance_deploy_name = char(instancedeploy{1,1}(j));
    instance_deploy(j,1) = str2double(instance_deploy_name(6:length(instance_deploy_name))); %get inst_no
    instance_app_name = char(instancedeploy{1,2}(j));
    instance_deploy(j,2) = str2double(instance_app_name(5:length(instance_app_name))); %get inst_no
    instance_machine_name = char(instancedeploy{1,3}(j));
    if ~isempty(instance_machine_name)
        instance_deploy(j,3) = str2double(instance_machine_name(9:length(instance_machine_name))); %get inst_no
    end
%    instance_deploy(j).Mach_Deploy_ID = [];
    instance_deploy(j,5) = app_resources(instance_deploy(j,2)).CPU_max;
    instance_deploy(j,6) = app_resources(instance_deploy(j,2) ).Disk;
    instance_deploy(j,7) = double(instance_deploy(j,5)) / 32 + double(instance_deploy(j,6)) / 1024;
end

%% get machine resources data
fid = fopen([data_path,'\scheduling_preliminary_machine_resources_20180606.csv']);
machineresources = textscan(fid, '%s%d%d%d%d%d%d','delimiter', ',');
fclose(fid);

for i = 1:6000
    machine_resources(i).ID = machineresources{1,1}(i);
    machine_resources(i).CPU = machineresources{1,2}(i);
    machine_resources(i).MEM = machineresources{1,3}(i);
    machine_resources(i).Disk = machineresources{1,4}(i);
    machine_resources(i).P = machineresources{1,5}(i);
    machine_resources(i).M = machineresources{1,6}(i);
    machine_resources(i).PM = machineresources{1,7}(i);
    machine_resources(i).Full = 'false';
    machine_resources(i).APP_Deploy = [];
    machine_resources(i).CPU_Used = 0;
    machine_resources(i).MEM_Used = 0;
    machine_resources(i).CPU_Used_s = zeros(1,98);
    machine_resources(i).MEM_Used_s = zeros(1,98);
    machine_resources(i).Disk_Used = 0;
    machine_resources(i).P_Used = 0;
    machine_resources(i).M_Used = 0;
    machine_resources(i).PM_Used = 0;
end

end


