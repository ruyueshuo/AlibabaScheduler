function [inter_info,inst_move] = inst_inter_check(instance_deploy,app_inter_mat)
inter_info.Machine_no=[];
inter_info.apps=[];
inst_move = [];
table_machine_deployed = tabulate(instance_deploy(:,3));
mm = 1;
for i = 1 : length(table_machine_deployed)
    if table_machine_deployed(i,1) == 0
        continue
    else
        machine_no = table_machine_deployed(i,1);
        vec_no = find(instance_deploy(:,3) == table_machine_deployed(i,1));
        app_no_in_machine = instance_deploy(vec_no,2);
        inst_no_in_machine = instance_deploy(vec_no,1);
        [inter_flag,inter_app,inter_move_no] = check_interference_1([],app_no_in_machine,app_inter_mat);
        if strcmp(inter_flag, 'true')
            inter_info(mm).Machine_no = machine_no;
            inter_info(mm).apps = inter_app;
            inter_info(mm).inter_move_no = inter_move_no;
            size_apps = size(inter_app);
            for ii= 1:size_apps(1)
                app_move_no = inter_app(ii,2);
                inst_move_no = inter_move_no(ii);
                inst_vec = find(instance_deploy(vec_no,2) == app_move_no);
                inst_no = inst_no_in_machine(inst_vec);
                for jj = 1:inst_move_no
                    inst_move = [inst_move;inst_no(jj)];
                end
            end
            mm=mm+1;
        end
    end
end