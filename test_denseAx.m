clear all

Ts = floor(10.^(1:0.25:4));

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
    
    % generate random data
    x = ones(T,1);
    A = ones(T,T);
    y = zeros(T,1);
    
    % cpu
    if T <= 1e7
        timer_cpu = tic;
        for n=1:Ntests
            y = A*x;
        end
        times_cpu(i) = toc(timer_cpu)/Ntests;
    else
        times_cpu(i) = Inf; % I don't have a whole day to wait, sorry
    end
    
    % gpu
    if have_gpu
        if T < 1e5
            x_gpu = gpuArray(x);
            A_gpu = gpuArray(A);
            y_gpu = gpuArray(y);
            timer_gpu = tic;
            for n=1:Ntests
                y_gpu = A_gpu*x_gpu;
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
save('results/zenbook_denseAx.mat','myresults');

