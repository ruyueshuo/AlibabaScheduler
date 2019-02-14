function [full_flag,overload_flag] = check_full(machine_resource)
full_flag = 'false';
overload_flag = 'false';

if (machine_resource.CPU_Used / double(machine_resource.CPU)) > 0.62
    full_flag = 'true';
end
if (machine_resource.CPU_Used / double(machine_resource.CPU)) > 1
    overload_flag = 'true';
end

if (machine_resource.MEM_Used / double(machine_resource.MEM)) > 0.95
    full_flag = 'true';
end
if machine_resource.MEM_Used > machine_resource.MEM
    overload_flag = 'true';
end

if (double(machine_resource.Disk_Used) / double(machine_resource.Disk)) > 0.95
    full_flag = 'true';
end

if (double(machine_resource.Disk_Used) / double(machine_resource.Disk)) > 1
    overload_flag = 'true';
end

if machine_resource.P_Used >= machine_resource.P
    full_flag = 'true';
end

if machine_resource.M_Used >= machine_resource.M
    full_flag = 'true'; 
end

if machine_resource.PM_Used >= machine_resource.PM
    full_flag = 'true'; 
end
end

                         