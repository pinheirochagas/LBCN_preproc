function trialinfo = CompTrialinfo(trialinfo, project_name)

switch project_name
    case 'Calculia'
        trialinfo.keys = [];
        for i = 1:size(trialinfo,1)
            if trialinfo.isActive(i) == 1
                trialinfo.condNames(i) = {[trialinfo.condNames{i} '_active']};
            else
                trialinfo.condNames(i) = {[trialinfo.condNames{i} '_passive']};
            end
        end
        
         for i = 1:size(trialinfo,1)
            if trialinfo.isDelayed(i) == 1
                trialinfo.condNames(i) = {[trialinfo.condNames{i} '_delayed']};
            else
                trialinfo.condNames(i) = {[trialinfo.condNames{i} '_non_delayed']};
            end
         end
         
         for i = 1:size(trialinfo,1)
             if trialinfo.isCalc(i) == 1 && trialinfo.isDelayed(i) == 1 && trialinfo.Correctness(i) == 1
                 trialinfo.correctness(i) = {'digit_correct_delayed'};
             elseif trialinfo.isCalc(i) == 1 && trialinfo.isDelayed(i) == 1 && trialinfo.Correctness(i) == 0
                 trialinfo.correctness(i) = {'digit_incorrect_delayed'};
             elseif trialinfo.isCalc(i) == 1 && trialinfo.isDelayed(i) == 0 && trialinfo.Correctness(i) == 1
                 trialinfo.correctness(i) = {'digit_correct_non_delayed'};
             elseif trialinfo.isCalc(i) == 1 && trialinfo.isDelayed(i) == 0 && trialinfo.Correctness(i) == 0
                 trialinfo.correctness(i) = {'digit_incorrect_non_delayed'};   
                 
             elseif trialinfo.isCalc(i) == 0 && trialinfo.isDelayed(i) == 1 && trialinfo.Correctness(i) == 1
                 trialinfo.correctness(i) = {'letter_correct_delayed'};
             elseif trialinfo.isCalc(i) == 0 && trialinfo.isDelayed(i) == 1 && trialinfo.Correctness(i) == 0
                 trialinfo.correctness(i) = {'letter_incorrect_delayed'};
             elseif trialinfo.isCalc(i) == 0 && trialinfo.isDelayed(i) == 0 && trialinfo.Correctness(i) == 1
                 trialinfo.correctness(i) = {'letter_correct_non_delayed'};
             elseif trialinfo.isCalc(i) == 0 && trialinfo.isDelayed(i) == 0 && trialinfo.Correctness(i) == 0
                 trialinfo.correctness(i) = {'letter_incorrect_non_delayed'}; 
                 
                 
                 
             end
         end
         
         
         
         
         
        
    case 'MMR'
        for i = 1:size(trialinfo,1)
            if trialinfo.isCalc(i) == 1
                if trialinfo.AbsDeviant(i) == 0
                    trialinfo.correctness{i} = 'correct';
                elseif trialinfo.AbsDeviant(i) > 0
                    trialinfo.correctness{i} = 'incorrect';
                else
                end
            else
                trialinfo.correctness{i} = 'no math';
            end
        end
        
    case 'Context'
        trialinfo.condNames2 = trialinfo.condNames;
        trialinfo.condNamesBasic = trialinfo.condNames;
        for i = 1:size(trialinfo,1)
            if trialinfo.isActive(i) == 1
                trialinfo.condNames(i) = {[trialinfo.condition{i} '_active']};
                trialinfo.condNamesBasic(i) = {'active'};
            else
                trialinfo.condNames(i) = {[trialinfo.condition{i} '_passive']};
                trialinfo.condNamesBasic(i) = {'passive'};
            end
        end
        
        trialinfo.correctness = trialinfo.condNames;
        trialinfo.correctness_basic = trialinfo.condNames;

        trialinfo.condNamesBasic = trialinfo.condNames;
        for i = 1:size(trialinfo,1)
            if trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 1 && strcmp(trialinfo.condition{i}, 'numerals')
                trialinfo.correctness{i} = 'digit_correct_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 1 && strcmp(trialinfo.condition{i}, 'numerals')
                trialinfo.correctness{i} = 'digit_correct_passive';
            elseif trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 0 && strcmp(trialinfo.condition{i}, 'numerals')
                trialinfo.correctness{i} = 'digit_incorrect_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 0 && strcmp(trialinfo.condition{i}, 'numerals')
                trialinfo.correctness{i} = 'digit_incorrect_passive';
                
            elseif trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 1 && strcmp(trialinfo.condition{i}, 'numword')
                trialinfo.correctness{i} = 'numword_correct_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 1 && strcmp(trialinfo.condition{i}, 'numword')
                trialinfo.correctness{i} = 'numword_correct_passive';
            elseif trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 0 && strcmp(trialinfo.condition{i}, 'numword')
                trialinfo.correctness{i} = 'numword_incorrect_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 0 && strcmp(trialinfo.condition{i}, 'numword')
                trialinfo.correctness{i} = 'numword_incorrect_passive';
            end
        end
        
        for i = 1:size(trialinfo,1)
            if trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 1 
                trialinfo.correctness_basic{i} = 'correct_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 1 
                trialinfo.correctness_basic{i} = 'correct_passive';
            elseif trialinfo.isActive(i) == 1 && trialinfo.Correctness(i) == 0 
                trialinfo.correctness_basic{i} = 'incorrect_active';
            elseif trialinfo.isActive(i) == 0 && trialinfo.Correctness(i) == 0 
                trialinfo.correctness_basic{i} = 'incorrect_passive';
            end           
        end
        
    case 'Calculia_verification_digit'
        
        trialinfo.correctness = trialinfo.condNames;
        trialinfo.delayed = trialinfo.condNames;

        for i = 1:size(trialinfo,1)
            if trialinfo.correct(i) == 1 && trialinfo.delay(i) == 1
                trialinfo.correctness{i} = 'correct_delay';
            elseif trialinfo.correct(i) == 0 && trialinfo.delay(i) == 1
                trialinfo.correctness{i} = 'incorrect_delay';
            elseif trialinfo.correct(i) == 1 && trialinfo.delay(i) == 0
                trialinfo.correctness{i} = 'correct_no_delay';
            elseif trialinfo.correct(i) == 0 && trialinfo.delay(i) == 0
                trialinfo.correctness{i} = 'incorrect_no_delay';
            end
        end
        
        for i = 1:size(trialinfo,1)
            if trialinfo.delay(i) == 1
                trialinfo.delayed{i} = 'delay';
            elseif trialinfo.delay(i) == 0
                trialinfo.delayed{i} = 'no_delay';
            end
        end

        
        
    case 'EglyDriver'
        %             interval_tmp = discretize(trialinfo.int_cue_targ_time, 5);
        %             trialinfo.condNames_interval = cellstr(num2str(interval_tmp));
        for i = 1:size(trialinfo,1)
            if trialinfo.cue_pos(i) == 1 || trialinfo.cue_pos(i) == 2
                trialinfo.CondNamesCueLoc{i} = [trialinfo.CondNames{i} '_cue_left'];
            else
                trialinfo.CondNamesCueLoc{i} = [trialinfo.CondNames{i} '_cue_right'];
            end
            
            
            
        end
        trialinfo.response_time(trialinfo.response_time == 0) = nan;
        
        
        
    case 'EglyDriver_stim'
        for i = 1:size(trialinfo,1)
            if trialinfo.TTL(i,3) == 128
                trialinfo.CondNames{i} = [trialinfo.CondNames{i} '_stim'];
            else
                trialinfo.CondNames{i} = [trialinfo.CondNames{i} '_nostim'];
            end
        end
        
    case 'VTCLoc'
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'numbers') == 1
                trialinfo.condNames_numbers{i} = 'numbers';
            else
                trialinfo.condNames_numbers{i} = 'other';
            end
        end
        
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'faces') == 1
                trialinfo.condNames_faces{i} = 'faces';
            else
                trialinfo.condNames_faces{i} = 'other';
            end
        end  
        
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'words') == 1
                trialinfo.condNames_words{i} = 'words';
            else
                trialinfo.condNames_words{i} = 'other';
            end
        end           
      
        
         for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'bodies') == 1
                trialinfo.condNames_bodies{i} = 'bodies';
            else
                trialinfo.condNames_bodies{i} = 'other';
            end
        end           
        
    case 'ReadNumWord'
        
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'number') == 1
                trialinfo.condNames_number{i} = 'numbers';
            else
                trialinfo.condNames_number{i} = 'other';
            end
        end
        
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'words') == 1
                trialinfo.condNames_words{i} = 'words';
            else
                trialinfo.condNames_words{i} = 'other';
            end
        end    
        
        for i = 1:size(trialinfo,1)
            if strcmp(trialinfo.condNames(i), 'number_word') == 1
                trialinfo.condNames_number_words{i} = 'number_words';
            else
                trialinfo.condNames_number_words{i} = 'other';
            end
        end     
        
        
case 'Memoria'
        
        for i = 1:size(trialinfo,1)
            if trialinfo.AbsDeviant(i) == 0 
                trialinfo.correctness{i} = 'correct';
            elseif trialinfo.AbsDeviant(i) > 0 
                trialinfo.correctness{i} = 'incorrect';
            else
                trialinfo.correctness{i} = ' ';
            end
        end
        
        
        for i = 1:size(trialinfo,1)
            if trialinfo.AbsDeviant(i) == 0 && strcmp(trialinfo.mathtype{i}, 'digit')
                trialinfo.correctness_math_type{i} = 'digit_correct';
            elseif trialinfo.AbsDeviant(i) == 0 && strcmp(trialinfo.mathtype{i}, 'numword')
                trialinfo.correctness_math_type{i} = 'numword_correct';
            elseif trialinfo.AbsDeviant(i) > 0 && strcmp(trialinfo.mathtype{i}, 'digit')
                trialinfo.correctness_math_type{i} = 'digit_incorrect';
            elseif trialinfo.AbsDeviant(i) > 0 && strcmp(trialinfo.mathtype{i}, 'numword')
                trialinfo.correctness_math_type{i} = 'numword_incorrect';                
            else
                trialinfo.correctness_math_type{i} = ' ';
            end
        end
        
        
end

end

