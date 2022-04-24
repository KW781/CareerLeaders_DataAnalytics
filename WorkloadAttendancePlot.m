function [] = WorkloadAttendancePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column numbers with the P2B event attendance data
    video_column_number = -1;
    mock_column_number = -1;
    kpmg_column_number = -1;
    workload_column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        %search for the column number with the video interview data
        if WithinWord('video interview', headings{i})
            video_column_number = i;
        end
        %search for the column number with the mock interview data
        if WithinWord('mock interview', headings{i})
            mock_column_number = i;
        end
        %search for the column number with the KPMG dinner/quiz data
        if WithinWord('Did you attend the KPMG', headings{i})
            kpmg_column_number = i;
        end
        %search for the column number with the workload opinion data
        if WithinWord('workload', headings{i}) && WithinWord('programme', headings{i})
            workload_column_number = i;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up the counters for each event attendance, plus workload
    %also write the legend labels for the pie charts
    video_attended = [0, 0];
    mock_attended = [0, 0];
    kpmg_attended = [0, 0];
    workload_opinion = [0, 0];
    attendance_labels = {'Attended', 'Did not attend'};
    workload_labels = {'About right', 'Too much work'};
    
    %count up the attendance and workload opinions
    for row = 1 : num_students
        %count up attendence for the video interview
        if strcmp(table{row, video_column_number}, 'Yes')
            video_attended(1) = video_attended(1) + 1;
        elseif strcmp(table{row, video_column_number}, 'No')
            video_attended(2) = video_attended(2) + 1;
        end
        %count up attendance for the mock interview
        if strcmp(table{row, mock_column_number}, 'Yes')
            mock_attended(1) = mock_attended(1) + 1;
        elseif strcmp(table{row, mock_column_number}, 'No')
            mock_attended(2) = mock_attended(2) + 1;
        end
        %count up attendance for the KPMG dinner
        if strcmp(table{row, kpmg_column_number}, 'Yes')
            kpmg_attended(1) = kpmg_attended(1) + 1;
        elseif strcmp(table{row, kpmg_column_number}, 'No')
            kpmg_attended(2) = kpmg_attended(2) + 1;
        end
        %count up opinions on workload
        if strcmp(table{row, workload_column_number}, 'About right')
            workload_opinion(1) = workload_opinion(1) + 1;
        elseif strcmp(table{row, workload_column_number}, 'Too much to do')
            workload_opinion(2) = workload_opinion(2) + 1;
        end
    end
    
    %plot the data in subplots
    subplot(2, 2, 1);
    pie(video_attended);
    legend(attendance_labels);
    title('Attendance at video interview');
    subplot(2, 2, 2);
    pie(mock_attended);
    legend(attendance_labels);
    title('Attendance at mock interview');
    subplot(2, 2, 3);
    pie(kpmg_attended);
    legend(attendance_labels);
    title('Attendance at KPMG dinner');
    subplot(2, 2, 4);
    pie(workload_opinion);
    legend(workload_labels);
    title('Opinion on P2B workload')
   end
    