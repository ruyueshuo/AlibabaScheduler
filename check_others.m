function [others_flag] = check_others(app_resource,machine_resource)
others_flag = 'false';

% machine_resource.CPU_Used = machine_resource.CPU_Used + max(app_resource.CPU);
for i = 1 : 98
    machine_resource.CPU_Used_s(i) = app_resource.CPU(i) + machine_resource.CPU_Used_s(i);
    machine_resource.MEM_Used_s(i) = app_resource.MEM(i) + machine_resource.MEM_Used_s(i);
end
if max(machine_resource.CPU_Used_s) >= (double(machine_resource.CPU) * 0.65)
    others_flag = 'true';
end

if max(machine_resource.MEM_Used_s) > machine_resource.MEM
    others_flag = 'true';
end

if (machine_resource.Disk_Used + app_resource.Disk) > machine_resource.Disk
    others_flag = 'true';
end

if (machine_resource.P_Used + app_resource.P) > machine_resource.P
    others_flag = 'true';
end

if (machine_resource.M_Used + app_resource.M) > machine_resource.M
    others_flag = 'true'; 
end

if (machine_resource.PM_Used + app_resource.PM) > machine_resource.PM
    others_flag = 'true'; 
end
end

                         