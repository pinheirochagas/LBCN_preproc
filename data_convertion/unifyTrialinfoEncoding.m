function ti = unifyTrialinfoEncoding(project_name, ti)
%%

% Task general_cond_name
% number_reading ---------------- 1                  
% number_identification --------- 2
% calculation_simoultaneous ----- 3
% calculation_sequential -------- 4
% memory_simoultaneous ---------- 5
% memory_sequential ------------- 6
% rest  ------------------------- 7
% attention --------------------- 8
% 
% 
% Number format
% digit ------------------------- 1
% dot --------------------------- 2
% word -------------------------- 3
% 
% 
% Calculation specs
% operand_1
% operand_2
% operand_min
% operand_max
% operation
% result
% presented_result
% deviant
% abs_deviant
% cross_decade ----------------- 1 (no) 2 (yes)
% ls_sl ------------------------ 1 (l+s) 2 (s+l)
% 
% Number specs
% number_of_digits
% size_on_screen - visual angle - to be calculatesd
% 
% Memory specs
% memory type
%        autobio --------------- 1
%        other  ---------------- 2
%        self-external  -------- 3
%        self-internal  -------- 4

%        
% autobio_general
% autobio_medical
% fact
% time (present, recent )


switch project_name
    case 'MMR'
        
        %% Basics
        for i = 1:size(ti,1)
            if strcmp(ti.condNames{i}, 'math')
                task_general_cond_name{i,1} = 'calculation_simultaneous';
            elseif strcmp(ti.condNames{i}, 'rest')
                task_general_cond_name{i,1} = 'rest';
            else
                task_general_cond_name{i,1} = 'memory_simultaneous';
            end
            
            % Task type
            if strcmp(ti.condNames{i}, 'rest')
                task_type{i,1} = 'passive';
            else
                task_type{i,1} = 'active';
            end
        end
        
        
        %% Math
        % Number format
        for i = 1:size(ti,1)
            if strcmp(ti.condNames{i}, 'math')
                number_format{i,1} = 'digit';
            else
                number_format{i,1} = nan;
            end
        end
        
        operand_1 = ti.Operand1;
        operand_2 = ti.Operand2;
        operand_min = ti.OperandMin;
        operand_max = ti.OperandMax;
        operation = ti.Operator; % 1 for addition and -1 for subtraction
        result = ti.CorrectResult;
        presented_result = ti.PresResult;
        deviant = ti.Deviant;
        abs_deviant = ti.AbsDeviant;
        
        for i = 1:size(ti,1)
            if ~strcmp(ti.condNames{i}, 'math')
                operand_1(i) = nan;
                operand_2(i) = nan;
                operand_min(i) = nan;
                operand_max(i) = nan;
                operation(i) = nan;
                result(i) = nan;
                presented_result(i) = nan;
                deviant(i) = nan;
                abs_deviant(i) = nan;
            else
            end
        end
        
        % Cross decade
        for i = 1:size(ti,1)
            if strcmp(ti.condNames{i}, 'math')
                max_tmp = num2str(ti.OperandMax(i));
                res_tmp = num2str(ti.CorrectResult(i));
                if strcmp(max_tmp(1), res_tmp(1))
                    cross_decade(i,1) = 0;
                else
                    cross_decade(i,1) = 1;
                end
                
            else
                cross_decade(i,1) = nan;
            end
            
        end
        
        % Smaller + larger or larger + smaller
        for i = 1:size(ti,1)
            if strcmp(ti.condNames{i}, 'math')
                if operand_1(i) > operand_2(i)
                    sl_ls{i,1} = 'l+s';
                elseif operand_1(i) < operand_2(i)
                    sl_ls{i,1} = 's+l';
                else
                    sl_ls{i,1} = 'tie';
                end
            else
                sl_ls{i,1} = nan;
            end
        end
        
        % Number of digits
        for i = 1:size(ti,1)
            number_of_digits(i,1) = length(regexp(ti.wlist{i},'\d'));
        end
        
        %% Memory
        memory_type = ti.condNames
        
        for i = 1:size(ti,1)
            if ~strcmp(ti.conds_math_memory{i}, 'memory')
                memory_type{i} = nan;
            else
            end
        end
        
        %% Behavioral performance
        for i = 1:size(ti,1)
            % Keys
            if isempty(ti.keys{i})
                keys(i,1) = nan;
            else
                if isempty(str2num(ti.keys{i}))
                    keys(i,1) = nan;
                else
                    keys(i,1) = str2num(ti.keys{i});
                end
            end
            
            
        end
        % RT
        RT = ti.RT;
        RT(RT == 0) = nan;
        
        % Accuracy
        accuracy = ti.Accuracy;
        accuracy(~strcmp(ti.condNames, 'math'),:) = nan;
        
        
        
    case 'Memoria'
        
        
        
end



% Unified trialinfo
ti = table;
ti.task_general_cond_name = task_general_cond_name;
ti.task_type = task_type;

% Math
ti.number_format = number_format;
ti.operand_1 = operand_1;
ti.operand_2 = operand_2;
ti.operand_min = operand_min;
ti.operand_max = operand_max;
ti.operation = operation; % 1 for addition and -1 for subtraction
ti.result = result;
ti.presented_result = presented_result;
ti.deviant = deviant;
ti.abs_deviant = abs_deviant;

% Memory
ti.memory_type = memory_type;

% Behavioral performance
ti.RT = RT;
ti.accuracy = accuracy;


%% Convert trialinfo table to numerical matrix





end

