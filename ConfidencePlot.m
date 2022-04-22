function [] = ConfidencePlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column numbers with the data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if strcmp(headings{i}, 'Please rate your confidence at the beginning of the programme in:')
            column_number = i;
            break;
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    
    career_skills = {'Engaging with industry', 'Developing networks', 'Applying for jobs'};
    total_skill_levels_before = zeros(1, length(career_skills));
    total_skill_levels_after = zeros(1, length(career_skills));
    for after = 0 : 1 %loop for both before after after P2B
        for skill = 1 : length(career_skills)
            col = length(career_skills) * after + column_number + skill - 1;
            for row = 1 : num_students
                if strcmp(table{row, col}, 'Not confident')
                    skill_level = 1;
                elseif strcmp(table{row, col}, 'Slightly confident')
                    skill_level = 2;
                elseif strcmp(table{row, col}, 'Confident')
                    skill_level = 3;
                elseif strcmp(table{row, col}, 'Very confident')
                    skill_level = 4;
                end
                
                if after
                    total_skill_levels_after(skill) = total_skill_levels_after(skill) + skill_level;
                else
                    total_skill_levels_before(skill) = total_skill_levels_before(skill) + skill_level;
                end
            end
        end
    end
    
    %calculate average skill levels
    avg_skill_levels_before = [];
    for i = 1 : length(total_skill_levels_before)
        avg_skill_levels_before(i) = total_skill_levels_before(i) / num_students;
        avg_skill_levels_after(i) = total_skill_levels_after(i) / num_students;
    end
    
    %create the categorical data from career skills
    ordinal_career_skills = categorical(career_skills);
    %reorder the categories since they're alphabetically sorted by default
    ordinal_career_skills = reordercats(ordinal_career_skills, career_skills);
    
    %plot the data
    colours = rand(length(ordinal_career_skills), 3); %generate the colours for the bars
    
    %first subplot for before
    subplot(1, 2, 1);
    bar_plot = bar(ordinal_career_skills, avg_skill_levels_before, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_skill_levels_before),...
        avg_skill_levels_before,...
        num2str(avg_skill_levels_before'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Confidence in career development skills before P2B (1 to 4)');
    xlabel('Career skill');
    ylabel('Average rating of skill');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)
    
    %second subplot for after
    subplot(1, 2, 2);
    bar_plot = bar(ordinal_career_skills, avg_skill_levels_after, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars in the plot
    text(1 : length(avg_skill_levels_after),...
        avg_skill_levels_after,...
        num2str(avg_skill_levels_after'),...
        'vert', 'bottom', 'horiz', 'center'); %add text labels for the percentage to each bar
    title('Confidence in career development skills after P2B (1 to 4)');
    xlabel('Career skill');
    ylabel('Average rating of skill');
    ylim([0, 4]); %ensure the y-axis spans from 0 to 4 (the range of skill ratings)    
end