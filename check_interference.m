function [inter_flag] = check_interference_2(app_no,app_in_machine,app_inter_mat)
inter_flag = 'false';

if isempty(app_in_machine)
    inter_flag = 'false';
else
    apps_in_machine = [app_in_machine;app_no];
    table_apps_in_machine = tabulate(apps_in_machine/2);
    table_apps_in_machine(:,1)=table_apps_in_machine(:,1) * 2;
    a_index= find(table_apps_in_machine(:,2)~=0);
    for mm = 1 : length(a_index)
        table_app_in_machine(mm,:) = table_apps_in_machine(a_index(mm),:);
    end
%     table_app_in_machine(:,1)=
    for i = 1 : length(table_app_in_machine(:,1))
        for j = 1 : length(table_app_in_machine(:,1))
            app1_no = table_app_in_machine(i,1);
            app2_no = table_app_in_machine(j,1);
            if i == j
                if (app_inter_mat(app1_no,app1_no) ~= 0)
                    if (table_app_in_machine(j,2)) > app_inter_mat(app2_no,app2_no)
                        inter_flag = 'true';                       
                    end
                end
            else
                if (app_inter_mat(app1_no,app2_no) ~= 0)
                    if (table_app_in_machine(j,2)) > (app_inter_mat(app1_no,app2_no) - 1)
                        inter_flag = 'true';                         
                    end
                end
            end
        end
    end
end
end