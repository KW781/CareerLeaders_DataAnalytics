function [] = JobTitlesPlot(file_name, recent_param)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find column number with the most recent job title data
    col_count = 0; %counter to keep track of number of columns with job title data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Generic Title', headings{i})
            col_count = col_count + 1;
        end
        if col_count == recent_param
            column_number = i;
            break;
        end
    end
    
    %extract data dimensions and create job title arrays
    dimensions = size(table);
    num_students = dimensions(1);
    %Note that 'Other' should ALWAYS be the last element in the job_titles array
    job_titles = {'Manager', 'Auditor', 'Accountant', 'Banking', 'Advisor',...
                    'Administrator', 'Consultant', 'Analyst',...
                    'Engineer', 'Associate', 'Marketing', 'Solicitor',...
                    'Other'};
    job_title_counters = zeros(1, length(job_titles));
    
    %count students with the job titles
    for i = 1 : num_students
        %check if current table element is null
        null = isnan(table{i, column_number});
        if length(null) > 1 %will return an array for character vectors, so following check must be done
            null = 0;
        end
        if length(null) == 0
            null = 1; %set to null if the element is an empty string
        end
        
        if ~null
            found = 0;
            for j = 1 : length(job_titles)
                if WithinWord(job_titles{j}, table{i, column_number})
                    job_title_counters(j) = job_title_counters(j) + 1;
                    found = 1;
                    break;
                end
            end
            if ~found
                job_title_counters(length(job_title_counters)) = job_title_counters(length(job_title_counters)) + 1;
            end
        end
    end
    
    %calculate the percentages from counters, for non-zero job titles
    options_index = 0;
    final_job_titles = {};
    job_title_proportions = [];
    for i = 1 : length(job_title_counters)
        if round((job_title_counters(i) / num_students) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_job_titles{options_index} = job_titles{i};
            job_title_proportions(options_index) = round((job_title_counters(i) / sum(job_title_counters)) * 100, 2);
        end
    end
    
    %sort job titles in descending order using bubble sort
    no_more_swaps = 0;
    max_index = length(job_title_proportions) - 1; 
    while ~no_more_swaps
        no_more_swaps = 1;
        for i = 1 : max_index
            if job_title_proportions(i) < job_title_proportions(i + 1)
                temp_prop = job_title_proportions(i);
                temp_title = final_job_titles{i};
                job_title_proportions(i) = job_title_proportions(i + 1);
                final_job_titles{i} = final_job_titles{i + 1};
                job_title_proportions(i + 1) = temp_prop;
                final_job_titles{i + 1} = temp_title;
                no_more_swaps = 0;
            end
        end
        max_index = max_index - 1;
    end
    
    %plot the specific job types for the top 3 job titles, while excluding 'Other'
    num_jobs = 0; %counter for the number of jobs found that are not 'Other'
    for i = 1 : length(final_job_titles)
        if ~strcmp('Other', final_job_titles{i})
            num_jobs = num_jobs + 1;
            PlotSpecificJob(table, column_number + 1, final_job_titles{i}, num_jobs)
        end
        if num_jobs == 3
            break; %exit once we've plotted the top 3 job types
        end
    end
    
    ordinal_final_job_titles = categorical(final_job_titles); %change strings to categorical type
    
    %reorder categories since categorical() alphabetises them by default
    ordinal_final_job_titles = reordercats(ordinal_final_job_titles, final_job_titles);
    
    %plot the data
    figure(4);
    colours = rand(length(ordinal_final_job_titles), 3); %generate the colours for the bars
    %create percentage symbols array (because they need to be appended to the numbers when plotting)
    percent_arr = '';
    for i = 1 : length(job_title_proportions)
        percent_arr = [percent_arr; '%'];
    end
    %plot the actual data with colours and percent symbols generated
    bar_plot = bar(ordinal_final_job_titles, job_title_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    %set the upper and lower limits of the y-axis numbers
    limits = ylim;
    ylim([0, min([100, max([limits(2), max(job_title_proportions) + 5, max(job_title_proportions) * 1.1])])]);
    text(1 : length(job_title_proportions),...
        job_title_proportions,...
        [num2str(job_title_proportions'), percent_arr],...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Jobs currently taken by graduates');
    xlabel('Job title');
    ylabel('Percentage of graduates');   
end