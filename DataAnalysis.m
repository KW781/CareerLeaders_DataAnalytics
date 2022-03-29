disp('Drop-in Analysis Plots')
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp('');
disp('Recruitment Survey Plots');
disp('7. Plot of roles students applied to');
disp('8. Plot of reasons for not applying')

plot_number = input('Enter which number plot you want: ');
file_name = input('Enter the file name of the spreadsheet you want to analyse: ', 's');

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
end


