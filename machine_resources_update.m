function [machine_resources] = machine_resources_update(machine_resources,app_resources,app_no,style) 
if strcmp(style,'add')
     machine_resources.APP_Deploy = [machine_resources.APP_Deploy;app_no];
     for m = 1 : 98
         machine_resources.CPU_Used_s(m) = app_resources.CPU(m) + machine_resources.CPU_Used_s(m);
         machine_resources.MEM_Used_s(m) = app_resources.MEM(m) + machine_resources.MEM_Used_s(m);
     end
     machine_resources.CPU_Used = max(machine_resources.CPU_Used_s);
     machine_resources.MEM_Used = max(machine_resources.MEM_Used_s);
     machine_resources.Disk_Used = machine_resources.Disk_Used + max(app_resources.Disk);
     machine_resources.P_Used = machine_resources.P_Used + max(app_resources.P);
     machine_resources.M_Used = machine_resources.M_Used + max(app_resources.M);
     machine_resources.PM_Used = machine_resources.PM_Used + max(app_resources.PM);
elseif strcmp(style,'delete')
     temp1 = machine_resources.APP_Deploy;
     temp2 = find(temp1 == app_no);
     machine_resources.APP_Deploy(temp2(1)) = [];
     for m = 1 : 98
         machine_resources.CPU_Used_s(m) = machine_resources.CPU_Used_s(m) - app_resources.CPU(m);
         machine_resources.MEM_Used_s(m) = machine_resources.MEM_Used_s(m) - app_resources.MEM(m);
     end
     machine_resources.CPU_Used = max(machine_resources.CPU_Used_s);
     machine_resources.MEM_Used = max(machine_resources.MEM_Used_s);
     machine_resources.Disk_Used = machine_resources.Disk_Used - max(app_resources.Disk);
     machine_resources.P_Used = machine_resources.P_Used - max(app_resources.P);
     machine_resources.M_Used = machine_resources.M_Used - max(app_resources.M);
     machine_resources.PM_Used = machine_resources.PM_Used - max(app_resources.PM);
end
end
    