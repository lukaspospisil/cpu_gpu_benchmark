clear all

what_to_plot = 3; % 1=denseAx,2=dot,3=sum

if what_to_plot == 1
    mytitle = 'Dense matrix - vector multiplication';
    data{1} = load('results/sputnik_denseAx.mat');
    data{2} = load('results/zenbook_denseAx.mat');
end

if what_to_plot == 2
    mytitle = 'Dot product';
    data{1} = load('results/sputnik_dot.mat');
    data{2} = load('results/zenbook_dot.mat');
end

if what_to_plot == 3
    mytitle = 'Vector sum';
    data{1} = load('results/sputnik_sum.mat');
    data{2} = load('results/zenbook_sum.mat');
end

data{1}.name = 'sputnik';
data{1}.linetype = 's-';

data{2}.name = 'zenbook';
data{2}.linetype = 'o--';

figure
hold on

title(mytitle)

mylegend = cell(2*length(data),1);
for j=1:length(data)
    plot(data{j}.myresults.Ts,data{j}.myresults.times_cpu,data{j}.linetype,'Color',[0.8,0.0,0]);
    plot(data{j}.myresults.Ts,data{j}.myresults.times_gpu,data{j}.linetype,'Color',[0,0.0,0.8]);
    
    mylegend{2*j-1} = ['CPU ' data{j}.name];
    mylegend{2*j} = ['GPU ' data{j}.name];
end
    
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
xlabel('T')
ylabel('time [s]')

legend(mylegend)

grid on
hold off