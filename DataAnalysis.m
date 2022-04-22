disp('Drop-in Analysis Plots')
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp(newline);
disp('Recruitment Survey Plots');
disp('7. Plot of roles students applied to');
disp('8. Plot of reasons for not applying')
disp('9. Plot of extra-curriculars students take part in')
disp('10. Plot of stages students are in')
disp('11. Plot of business school events students attended')
disp(newline)
disp('P2B Survey Plots');
disp('13. Plot of confidence of students in career areas before and after');

%request the plot number from the user, until a valid one is entered
plot_number = -1;
while ~(plot_number >= 1 && plot_number <= 13)
    plot_number = input('Enter which number plot you want: ');
end
file_name = input('Enter the file name of the spreadsheet you want to analyse: ', 's');

%remove leading and trailing quotation marks
if strcmp(file_name(1), '"') || strcmp(file_name(1), '"')
    file_name = file_name(2 : length(file_name) - 1);
end

% try
    switch plot_number
        case 1
            FirstTimePlot(file_name);
        case 2
            AttendancePurposePlot(file_name);
        case 3
            FoundOutMethodPlot(file_name);
        case 4
            RolePlot(file_name);
        case 5
            YearLevelPlot(file_name);
        case 6
            OrganisationPlot(file_name);
        case 7
            RoleApplicationPlot(file_name);
        case 8
            ReasonsNotApplyPlot(file_name);
        case 9
            ExtracurricularsPlot(file_name);
        case 10
            StagesPlot(file_name);
        case 11
            EventAttendancePlot(file_name);
        case 13
            ConfidencePlot(file_name);
    end
% catch
%     disp('Something went wrong. Try again. Make sure you have given the correct spreadsheet for the plot you want.')
% end


