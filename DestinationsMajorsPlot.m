function [] = DestinationsMajorsPlot(file_name)
    table_raw = readtable(file_name);
    table = table2cell(table_raw);
    
    %find the column number with the majors data
    column_number = -1;
    headings = table_raw.Properties.VariableDescriptions;
    for i = 1 : length(headings)
        if WithinWord('Major', headings{i})
            column_number = i;
            break
        end
    end
    
    dimensions = size(table);
    num_students = dimensions(1);
    %array containing all the majors that will be shown on plot
    majors = {'Accounting', 'Economics', 'Finance', 'Commercial Law',...
                'Marketing', 'Information Systems', 'Business Analytics',...
                'Management', 'Taxation', 'Innovation and Entrepreneurship',...
                'Operations and Supply Chain Management', 'International Business'};
    %array containing how majors are identified in spreadsheet
    major_identifiers = {'Accounting', 'Economics', 'Finance', 'Commercial',...
                            'Marketing', 'Information', 'Analytics',...
                            'Management', 'Taxation', 'Innovation',...
                            'Operations', 'International'};
    major_counters = zeros(1, length(majors));
    
    %count the majors studied by the students
    for col = column_number : column_number + 2 
        for row = 1 : num_students 
            for i = 1 : length(majors)
                %compare the major across all the identifers (not case sensitive)
                if WithinWord(major_identifiers{i}, table{row, col})
                    major_counters(i) = major_counters(i) + 1; %increment the counter if match occurs
                    break;
                end
            end
        end
    end
    
    %calculate the percentages from counters, for non-zero majors
    options_index = 0;
    final_majors = {};
    major_proportions = [];
    for i = 1 : length(major_counters)
        if round((major_counters(i) / num_students) * 100, 2) ~= 0
            options_index = options_index + 1;
            final_majors{options_index} = majors{i};
            major_proportions(options_index) = round((major_counters(i) / num_students) * 100, 2);
        end
    end
    
    ordinal_final_majors = categorical(final_majors); %convert final major strings to categorical type
    
    %reorder categories, because categorical() sorts them alphabetically
    ordinal_final_majors = reordercats(ordinal_final_majors, final_majors);
    
    %plot the data
    colours = rand(length(ordinal_final_majors), 3); %randomly generate colours for bars
    bar_plot = barh(ordinal_final_majors, major_proportions, 'facecolor', 'flat');
    bar_plot.CData = colours; %colour in the bars
    xtips1 = bar_plot(1).YEndPoints + 0.3;
    ytips1 = bar_plot(1).XEndPoints;
    labels1 = string(bar_plot(1).YData) + '%';
    text(xtips1,ytips1,labels1,'VerticalAlignment','middle');  %add text labels for the percentage to each bar
    title('Percentages of graduates studying each major');
    xlabel('Percentage of graduates')
    ylabel('Majors')    
end