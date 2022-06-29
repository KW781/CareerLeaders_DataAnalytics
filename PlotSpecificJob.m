function [] = PlotSpecificJob(table, col_num, job, fig_num)
    dimensions = size(table);
    num_students = dimensions(1);
    
    %set up counter and job title arrays, then count through the spreadsheet
    job_types = {};
    job_type_counters = [];
    for student = 1 : num_students
        if WithinWord(job, table{student, col_num})        
            %check if current job title already exists in array
            match = 0;
            for i = 1 : length(job_types)
                if strcmp(table{student, col_num}, job_types{i})
                    %increment counter if it exists, and set match flag
                    job_type_counters(i) = job_type_counters(i) + 1;
                    match = 1;
                    break;
                end
            end
            %if it doesn't exist, add it to the job titles array
            if ~match
                job_types{length(job_types) + 1} = table{student, col_num};
                job_type_counters(length(job_type_counters) + 1) = 1;
            end
        end
    end
    
    ordinal_job_types = categorical(job_types); %convert strings to categorical type
    
    %reorder categories since categorical() alphabetises them
    ordinal_job_types = reordercats(ordinal_job_types, job_types);
    
    %plot the data
    figure(fig_num);
    colours = rand(length(ordinal_job_types), 3); %randomly generate colours for bars
    bar_plot = barh(ordinal_job_types, job_type_counters, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData);
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title(['Number of graduates in a ', job, ' role working in specific areas']);
    xlabel('Role area')
    ylabel('Number of graduates')       
end