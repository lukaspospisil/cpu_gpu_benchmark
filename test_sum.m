clear all

Ts = floor(10.^(2:0.5:8));

have_gpu = true; % do you have "right" gpu?
if have_gpu
    gpudev = gpuDevice();
end

times_cpu = zeros(size(Ts));
times_gpu = zeros(size(Ts));

Ntests = 1e2;

for i = 1:length(Ts)
    T = Ts(i);
    disp([ '- T = ' num2str(T) ' (' num2str(i) '/' num2str(length(Ts)) ')'])
    
    % generate some data
    x = ones(T,1);
    y = ones(T,1);
    z = zeros(T,1);
    
    % cpu
    if T <= 1e9
        timer_cpu = tic;
        for n=1:Ntests
            z = x + y;
        end
        times_cpu(i) = toc(timer_cpu)/Ntests;
    else
        times_cpu(i) = Inf; % I don't have a whole day to wait, sorry
    end
    
    % gpu
    if have_gpu
        if T <= 1e9 
            x_gpu = gpuArray(x);
            y_gpu = gpuArray(y);
            z_gpu = gpuArray(z);
            timer_gpu = tic;
            for n=1:Ntests
                z_gpu = x_gpu + y_gpu;
            end
            wait(gpudev)
            times_gpu(i) = toc(timer_gpu)/Ntests;
        else
            times_gpu(i) = Inf;
        end
    else
       times_gpu(i) = Inf;
    end
    
end

myresults.Ts = Ts;
myresults.times_cpu = times_cpu;
myresults.times_gpu = times_gpu;

% save results
save('results/sputnik_sum.mat','myresults');

