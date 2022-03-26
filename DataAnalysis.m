disp('Drop-in Analysis Plots')
disp('1. Plot of first time drop-in students');
disp('2. Plot of drop-in attendance purposes');
disp('3. Plot of how students found out about drop-in');
disp('4. Plot of roles drop-in students were applying for');
disp('5. Plot of the year levels of drop-in students');
disp('6. Plot of organisations drop-in students were applying to');
disp('Recruitment Survey Plots');
disp('7. Plot of roles students applied to');

plot_number = input('Enter which number plot you want: ');

switch plot_number
    case 1
        FirstTimePlot();
    case 2
        AttendancePurposePlot();
    case 3
        FoundOutMethodPlot();
    case 4
        RolePlot();
    case 5
        YearLevelPlot();
    case 6
        OrganisationPlot();
    case 7
        RoleApplicationPlot();
end


