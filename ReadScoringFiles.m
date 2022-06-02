%define variables: users, mouse id, root directory
UserID = ["CD", "RL", "UR" ];
MouseID = ["M9", "M10", "M11", "M12"]; 
%MouseID = ["M15", "M16", "M17", "M19"];
groupID = 'LAT1'; %name of the subject group
Results = {};
output = strcat('Z:\Lab\EEG_Lateralization\Seizure Scoring Output\',groupID,'Summary.mat');
clear Tables
for w = 1:6
    target = strcat('Z:\Lab\EEG_Lateralization\Seizure Scoring Output\',groupID,'\W',num2str(w),'\');
    disp(strcat('LAT2 W', num2str(w)))


    %get recording hour for each week - use ts files, that's consequent w/
    %the gui
    FileList = dir(strcat('Z:\Lab\EEG_Lateralization\',groupID, '\W', num2str(w),'\ts*.bin'));
    Nfile = length(FileList);
    hours = strings(Nfile,1);
    for h = 1:Nfile
        hours(h) = FileList(h).name(3:end-4);
    end

    %for outputting results
    Results = NaN(length(hours), 2*length(UserID), length(MouseID));
    weekname = strcat('W', num2str(w));
    firstrow = [UserID(1) UserID(1) UserID(2) UserID(2) UserID(3) UserID(3)];
    secondrow = ["Nseizure" "NBehav" "Nseizure" "NBehav" "Nseizure" "NBehav"];
    for student = 1:length(UserID)
        for mouse = 1:length(MouseID)
            if exist("ScoringList", 'var')
                clear ScoringList
            end
            if exist("Scoring", 'var')
                clear Scoring
            end
            %read all files from specific student, specific mouse
            ScoringList = dir(strcat(target, 'Scoring_', MouseID(mouse), '*', UserID(student), '*'));
            %if no data from this week
            if isempty(ScoringList)
                continue;
            end
            disp(strcat("Student: ", UserID(student)))
            disp(strcat("Mouse: ", ScoringList(1).name(9:11)))

            %look for files which belongs to same hour
            %get hours
            RecordingDate = strings(length(ScoringList),1);
            for i = 1:length(ScoringList)
                RecordingDate(i) = string(extractBetween(ScoringList(i).name, strcat(MouseID(mouse), '_'), strcat('_',UserID(student))));
            end

            %get same hours
            [~, ia, ic] = unique(RecordingDate);

            %merge files
            ctr=1;
            while ctr<=length(ScoringList)
                fieldname = strcat('hour', num2str(ctr));
                Scoring.(fieldname) = load(strcat(ScoringList(ctr).folder, '\', ScoringList(ctr).name));
                %check if scoring results is an empty struct (no LFPtype field)
                if ~isfield(Scoring.(fieldname).ScoredSeizures, 'LFPtype' )
                    Scoring = rmfield(Scoring,fieldname);
                    ctr = ctr+1;
                    continue;
                end
                idx = ic(ctr);
                subctr = ctr+1;
                if subctr <= length(ic)
                    %check the next files if it's the same hour/mouse
                    while idx == ic(subctr)
                        %read mat file
                        subfieldname = strcat('hour', num2str(ctr), '_', num2str(subctr));
                        Scoring.(subfieldname) = load(strcat(ScoringList(subctr).folder, '\', ScoringList(subctr).name));
                        %if file is empty, discard
                        if ~isfield(Scoring.(subfieldname).ScoredSeizures, 'LFPtype' )
                            Scoring = rmfield(Scoring,subfieldname);
                            subctr = subctr +1;
                            continue;
                        end

                        Nscored = length(Scoring.(subfieldname).ScoredSeizures.LFPtype);
                        %if there are, replace missing elements - always add to the very
                        %first
                        if sum(ismissing(Scoring.(subfieldname).ScoredSeizures.LFPtype)) > 0
                            idxx = find(~ismissing(Scoring.(subfieldname).ScoredSeizures.LFPtype));
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.LFPtype(idxx) = Scoring.(subfieldname).ScoredSeizures.LFPtype(idxx);
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.Hemisphere(idxx) = Scoring.(subfieldname).ScoredSeizures.Hemisphere(idxx);
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.Behavior(idxx) = Scoring.(subfieldname).ScoredSeizures.Behavior(idxx);
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.comment(idxx) = Scoring.(subfieldname).ScoredSeizures.comment(idxx);
                            Scoring = rmfield(Scoring,subfieldname);
                            %if there are less than N scoring and no missing field, replace the first few elements to the very first file
                        elseif Nscored< length(Scoring.(fieldname).ScoredSeizures.duration)
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.LFPtype(1:Nscored) = Scoring.(subfieldname).ScoredSeizures.LFPtype;
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.Hemisphere(1:Nscored) = Scoring.(subfieldname).ScoredSeizures.Hemisphere;
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.Behavior(1:Nscored) = Scoring.(subfieldname).ScoredSeizures.Behavior;
                            Scoring.(strcat('hour', num2str(ctr))).ScoredSeizures.comment(1:Nscored) = Scoring.(subfieldname).ScoredSeizures.comment;
                            Scoring = rmfield(Scoring,subfieldname);
                            %any other case replace the whole struct with the latter one
                        else
                            Scoring.(strcat('hour', num2str(ctr))) = Scoring.(subfieldname);
                            Scoring = rmfield(Scoring, subfieldname);
                        end
                        subctr = subctr +1;
                        ctr = ctr+1;
                        if subctr > length(ic)
                            break
                        end
                    end
                end

                %% merging of files ends here. Use the Scoring variable for further analysis
                
                %count behavioral seizures if classification contains 'Stage'

                %count seizures IF there is in this particular hour
                IsSeiz = find(Scoring.(fieldname).ScoredSeizures.LFPtype == 'Seizure');


                %counting behaviour seizures
                IsBehav = [];
                IsBehav = find(contains(Scoring.(fieldname).ScoredSeizures.Behavior,'Stage'));
                NBehav = 0;

                %count the actual number of behavior seizure if there was
                %any seizure
                if ~isempty(IsSeiz)
                    beh = 1;
                    while beh <= length(IsBehav)
                        BehavIdx = IsBehav(beh); %get the first behavioral seizure flag

                        %if this flag belongs to a 'Seizure' LFPtype, increment
                        %the counter
                        if Scoring.(fieldname).ScoredSeizures.LFPtype(BehavIdx) == 'Seizure'
                            NBehav = NBehav+1;
                            beh = beh+1;
                            %otherwise it's a continuation. Get the idxs of the
                            %neighbouring 'Seizure'
                        elseif Scoring.(fieldname).ScoredSeizures.LFPtype(BehavIdx) == 'Continuation'
                            %get previous seizure
                            previdx = BehavIdx-1;
                            while Scoring.(fieldname).ScoredSeizures.LFPtype(previdx) ~= 'Seizure'
                                previdx = previdx-1;
                            end
                            %get next seizure

                            nextidx = BehavIdx+1;
                            %if next idx does not exceed the range
                            if nextidx <=IsBehav(end)
                                while Scoring.(fieldname).ScoredSeizures.LFPtype(nextidx) ~= 'Seizure'
                                    nextidx = nextidx+1;
                                    if nextidx > length(Scoring.(fieldname).ScoredSeizures.LFPtype)
                                        break;
                                    end
                                end
                            end
                            %if the previous seizure was already a
                            %behavioral,does not count
                            if contains(Scoring.(fieldname).ScoredSeizures.Behavior(previdx), 'Stage')
                                beh = beh+1;
                                %otherwise count it and jump to the next seizure (nextidx)
                            else
                                NBehav = NBehav +1;
                                beh = beh+(nextidx-BehavIdx);
                            end
                        %else it was accidentally an artifact was marked as
                        %stage 1 
                        else
                            beh = beh+1;
                        end


                    end
                end
                hour = find(strcmp(hours, Scoring.(fieldname).ScoredSeizures.RecordingDate));
                % Seiz| Behav Seiz for each student (6 columns)

                Results(hour,2*student-1,mouse) = length(IsSeiz);
                Results(hour,2*student,mouse) = NBehav ;
                %get which hour is this

                disp(strcat("Hour: ", Scoring.(fieldname).ScoredSeizures.RecordingDate))
                disp(strcat("NSeiz = ", num2str(length(IsSeiz))))
                disp(strcat("NBehav = ", num2str(NBehav)))
                ctr = ctr+1;
            end

        end
    end
    %create tables for each week each mouse row = hour, col = students, 3rd axis =
    %mouse

    for m = 1:length(MouseID)
        tablename = MouseID(m);
        Tables.(groupID).(weekname).(tablename) = table([firstrow; secondrow;Results(:,:,m)]);
        Tables.(groupID).(weekname).(tablename).Properties.RowNames = ['User ID'; 'Counts';hours];
        Tables.(groupID).(weekname).(tablename).Properties.VariableNames = " ";
    end

    %save output
    save(output, "Tables");
end



