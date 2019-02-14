clc
clear
tic
%%
data_path = '...\datasets';
[app_inter_mat,app_resources,machine_resources,instance_deploy] = data_import(data_path);

disp('=============数据读取完毕！============');
disp('===========开始部署instance！==========');

inst_name = {};
mach_name = {};
%%
% check deployed data
[inter_info,inst_move] = inst_inter_check(instance_deploy,app_inter_mat);

% move to empty machine
table_inst_move = tabulate(inst_move/2);
table_inst_move(:,1)=table_inst_move(:,1) * 2;
empty_machine_no = [];
table_machine_deployed = tabulate(instance_deploy(:,3));
for i = 1:6000
    if isempty(find(i == table_machine_deployed(:,1)))
        empty_machine_no = [empty_machine_no;i];
    end
end
for i = 1:length(table_inst_move(:,1))
    inst_move_no = table_inst_move(i,1);
    temp_no = find(instance_deploy(:,1)==inst_move_no);
    instance_deploy(temp_no,3) = empty_machine_no(length(empty_machine_no)-i);
    inst_name = [inst_name;{['inst_',num2str(inst_move_no)]}];
    mach_name = [mach_name;{['machine_',num2str(instance_deploy(temp_no,3))]}];
end
%%
% clear and check deployed data
clear inter_info
[inter_info,inst_move] = inst_inter_check(instance_deploy,app_inter_mat);
if isempty(inter_info(:).Machine_no)
    disp('=========无冲突实例========');
end
%%
% deploy
n_instance = length(instance_deploy);
n_app = length(app_resources);
n_machine = length(machine_resources);
% machine_name = 'machine_';
machine_no = n_machine;
instance_not_deploy = [];
instance_not_deploy_app = [];
instance_not_deploy_mach = [];
% check machine resources
for i = 1: n_instance
    if (instance_deploy(i,3)~=0)
         app_no = instance_deploy(i,2);
         app_name_char = ['app_',num2str(i)];
         machine_no = instance_deploy(i,3);
         instance_deploy(i,3) = machine_no;
         [machine_resources_up] = machine_resources_update(machine_resources(machine_no),app_resources(app_no),app_no,'add'); 
         machine_resources(machine_no) = machine_resources_up;
         [full_flag,overload_flag] = check_full(machine_resources(machine_no));
         if strcmp(full_flag,'true')
             machine_resources(machine_no).Full = 'true';
         else
             machine_resources(machine_no).Full = 'false';
         end
         if strcmp(overload_flag,'true')
             disp(['第',num2str(machine_no),'个机器超负荷']);
         end
    end
end
%deploy
[instance_deploy,I]=sortrows(instance_deploy,-7); % deploy by resources 
for i = 1:n_instance
    machine_no = n_machine;
    app_no = instance_deploy(i,2);
    app_name_char = ['app_',num2str(app_no)];
    app_name = {['app_',num2str(app_no)]};
    if (instance_deploy(i,3)==0)
        instance_deploy_flag = 0;
        % deploy
         while (instance_deploy_flag == 0)
             if (machine_no ~= 0) 
                 if strcmp(machine_resources(machine_no).Full,'false')   
                         % check_others
                         [others_flag] = check_others(app_resources(app_no),machine_resources(machine_no));
                         if strcmp(others_flag,'false')
                             % check_interference
                             app_in_machine = machine_resources(machine_no).APP_Deploy;
                             [inter_flag,inter_app,inter_move_no] = check_interference_1(app_no,app_in_machine,app_inter_mat);
                             if  strcmp(inter_flag,'false')
                                 instance_deploy(i,3) = machine_no;
                                 [machine_resources_up] = machine_resources_update(machine_resources(machine_no),app_resources(app_no),app_no,'add');
                                 machine_resources(machine_no) = machine_resources_up;
                                 instance_deploy_flag = 1;
                                 inst_name = [inst_name;{['inst_',num2str(instance_deploy(i,1))]}];
                                 mach_name = [mach_name;{['machine_',num2str(machine_no)]}];
                                 [full_flag, overload_flag] = check_full(machine_resources(machine_no));
                                 if strcmp(full_flag,'true')
                                     machine_resources(machine_no).Full = 'true';
                                 end
                             else
                                 machine_no = machine_no - 1;
                             end
                         else
                              machine_no = machine_no - 1;
                         end
                 else
                        machine_no = machine_no - 1;   
                 end
             else
                 instance_not_deploy = [instance_not_deploy;i];
                 instance_not_deploy_app = [instance_not_deploy_app;app_no];
                 instance_deploy_flag = 1;
             end
         end
    end
    if rem(i,1000) == 0
        disp(['已经部署实例的个数为：',num2str(i)]);
    end
end
% check CPU-overload machine 
% count_cpu = 0;
no = [];
for i = 1:6000
    temp_a = [];
%     critia = (machine_resources(i).CPU_Used) - (0.6* double(machine_resources(i).CPU));
    while (machine_resources(i).CPU_Used) > (0.55* double(machine_resources(i).CPU))
        temp_a = [];

        no = [ no ; i];
        apps_no = [machine_resources(i).APP_Deploy];

        % randomly choice
        I=apps_no(randperm(length(apps_no)));
        %a=b(1);
        inst_move_no = intersect(find(instance_deploy(:,2)==I(1)), find(instance_deploy(:,3)==i));
        inst_move_no = inst_move_no(1);
%         for i = 1:n_instance
        machine_no = n_machine;
        app_no = instance_deploy(inst_move_no,2);
        instance_deploy_flag = 0;
            % deploy
         while (instance_deploy_flag == 0)
%              machine_no = n_machine;
             if (machine_no ~= 0) 
                 if strcmp(machine_resources(machine_no).Full,'false')   
                         % check_others
                         [others_flag] = check_others(app_resources(app_no),machine_resources(machine_no));
                         if strcmp(others_flag,'false')
                             % check_interference
                             app_in_machine = machine_resources(machine_no).APP_Deploy;
                             [inter_flag,inter_app,inter_move_no] = check_interference_1(app_no,app_in_machine,app_inter_mat);
                             if  strcmp(inter_flag,'false')
                                 instance_deploy(inst_move_no,3) = machine_no;
                                 [machine_resources_up] = machine_resources_update(machine_resources(machine_no),app_resources(app_no),app_no,'add');
                                 machine_resources(machine_no) = machine_resources_up;
                                 [machine_resources_up] = machine_resources_update(machine_resources(i),app_resources(app_no),app_no,'delete');
                                 machine_resources(i) = machine_resources_up;
                                 instance_deploy_flag = 1;
                                 inst_name = [inst_name;{['inst_',num2str(instance_deploy(inst_move_no,1))]}];
                                 mach_name = [mach_name;{['machine_',num2str(machine_no)]}];
                                 [full_flag, overload_flag] = check_full(machine_resources(machine_no));
                                 if strcmp(full_flag,'true')
                                     machine_resources(machine_no).Full = 'true';
                                 else
                                     machine_resources(machine_no).Full = 'false';
                                 end
                                 
                             else
                                 machine_no = machine_no - 1;
                             end
                         else
                              machine_no = machine_no - 1;
                         end
                 else
                        machine_no = machine_no - 1;   
                 end
             else
                 instance_not_deploy = [instance_not_deploy;i];
                 instance_not_deploy_app = [instance_not_deploy_app;app_no];
                 instance_not_deploy_mach = [instance_not_deploy_mach;i];
                 instance_deploy_flag = 1;
                 machine_resources(i).CPU_Used = 0.6 * machine_resources(i).CPU;
             end
         end
    if rem(i,100) == 0
        disp(['已经检查机器的个数为：',num2str(i)]);
    end
    end
    [full_flag] = check_full(machine_resources(i));
     if strcmp(full_flag,'true')
         machine_resources(i).Full = 'true';
     else
         machine_resources(i).Full = 'false';
     end
end

disp('===============部署完毕!================');
table_new = table(inst_name,mach_name );
writetable(table_new,'submit_20180814_B.csv','WriteVariableNames',false);
fid=fopen('submit_20180727_A.csv');
table_A= textscan(fid, '%s%s','delimiter', ',');
fid=fopen('submit_20180814_B.csv');
table_B= textscan(fid, '%s%s','delimiter', ',');
inst_name = [table_A{1,1};'#';table_B{1,1}];
machine_name = [table_A{1,2};'\n';table_B{1,2}];
table_new = table(inst_name,machine_name);
writetable(table_new,'submit_20180814.csv','WriteVariableNames',false);

toc
%%