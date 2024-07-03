% This script is an adaptation of Dr. J. Fortin's original source code.
% The original source code can be found at https://github.com/Jfortin1/ComBatHarmonization/tree/master/Matlab


% % brief demo
% data = randn(1000,10);
% batch = [1 1 1 1 1 2 2 2 2 2];
% mod = [1 2 1 2 1 2 1 2 1 2]';

% p=10000;
% n=10;
% batch = [1 1 1 1 1 2 2 2 2 2]; %Batch variable for the scanner id
% dat = randn(p,n); %Random data matrix
% age = [82 70 68 66 80 69 72 76 74 80]'; % Continuous variable
% sex = [1 2 1 2 1 2 1 2 1 2]'; % Categorical variable (1 for females, 2 for males)
% sex = dummyvar(sex);
% mod = [age sex(:,2)];
% data_harmonized = combat(dat, batch, mod, 1);

function [bayesdata,s_hat] = sp_combat(dat, batch, mod, parametric, verbose)
[sds] = std(dat')';
wh = find(sds==0);
[ns,ms] = size(wh);
if ns>0
    error('Error. There are rows with constant values across samples. Remove these rows and rerun ComBat.')
end
batchmod = categorical(batch);
batchmod = dummyvar({batchmod});
n_batch = size(batchmod,2);
levels = unique(batch);
if verbose == 1
    fprintf('[combat] Found %d batches\n', n_batch);
end

batches = cell(0);
for i=1:n_batch
    batches{i}=find(batch == levels(i));
end
n_batches = cellfun(@length,batches);
n_array = sum(n_batches);

% Creating design matrix and removing intercept:
design = [batchmod mod];
intercept = ones(1,n_array)';
wh = cellfun(@(x) isequal(x,intercept),num2cell(design,1));
bad = find(wh==1);
design(:,bad)=[];

if verbose == 1
    fprintf('[combat] Adjusting for %d covariate(s) of covariate level(s)\n',size(design,2)-size(batchmod,2))
end
% Check if the design is confounded
if rank(design)<size(design,2)
    nn = size(design,2);
    if nn==(n_batch+1)
        error('Error. The covariate is confounded with batch. Remove the covariate and rerun ComBat.')
    end
    if nn>(n_batch+1)
        temp = design(:,(n_batch+1):nn);
        if rank(temp) < size(temp,2)
            error('Error. The covariates are confounded. Please remove one or more of the covariates so the design is not confounded.')
        else
            error('Error. At least one covariate is confounded with batch. Please remove confounded covariates and rerun ComBat.')
        end
    end
end

if verbose == 1
    fprintf('[combat] Standardizing Data across features\n')
end
B_hat = inv(design'*design)*design'*dat';
%Standarization Model
grand_mean = (n_batches/n_array)*B_hat(1:n_batch,:);
var_pooled = ((dat-(design*B_hat)').^2)*repmat(1/n_array,n_array,1);
stand_mean = grand_mean'*repmat(1,1,n_array);
% Making sure pooled variances are not zero:
wh = find(var_pooled==0);
var_pooled_notzero = var_pooled;
var_pooled_notzero(wh) = [];
var_pooled(wh) = median(var_pooled_notzero);

if not(isempty(design))
    tmp = design;
    tmp(:,1:n_batch) = 0;
    stand_mean = stand_mean+(tmp*B_hat)';
end
s_data = (dat-stand_mean)./(sqrt(var_pooled)*repmat(1,1,n_array));

%Get regression batch effect parameters
if verbose == 1
    fprintf('[combat] Fitting L/S model and finding priors\n')
end
batch_design = design(:,1:n_batch);
gamma_hat = inv(batch_design'*batch_design)*batch_design'*s_data';
delta_hat = [];
for i=1:n_batch
    indices = batches{i};
    delta_hat = [delta_hat; var(s_data(:,indices)')];
end

%Find parametric priors:
gamma_bar = mean(gamma_hat');
t2 = var(gamma_hat');
delta_hat_cell = num2cell(delta_hat,2);
a_prior=[]; b_prior=[];
for i=1:n_batch
    a_prior=[a_prior aprior(delta_hat_cell{i})];
    b_prior=[b_prior bprior(delta_hat_cell{i})];
end


if parametric
    if verbose == 1
        fprintf('[combat] Finding parametric adjustments\n')
    end
    gamma_star =[]; delta_star=[];
    for i=1:n_batch
        indices = batches{i};
        temp = itSol(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:),gamma_bar(i),t2(i),a_prior(i),b_prior(i), 0.001);
        gamma_star = [gamma_star; temp(1,:)];
        delta_star = [delta_star; temp(2,:)];
    end
end

if (1-parametric)
    gamma_star =[]; delta_star=[];
    if verbose == 1
        fprintf('[combat] Finding non-parametric adjustments\n')
    end
    for i=1:n_batch
        indices = batches{i};
        temp = inteprior(s_data(:,indices),gamma_hat(i,:),delta_hat(i,:));
        gamma_star = [gamma_star; temp(1,:)];
        delta_star = [delta_star; temp(2,:)];
    end
end
if verbose == 1
    fprintf('[combat] Adjusting the Data\n')
end
bayesdata = s_data;
j = 1;
for i=1:n_batch
    indices = batches{i};
    bayesdata(:,indices) = (bayesdata(:,indices)-(batch_design(indices,:)*gamma_star)')./(sqrt(delta_star(j,:))'*repmat(1,1,n_batches(i)));
    j = j+1;
end
bayesdata = (bayesdata.*(sqrt(var_pooled)*repmat(1,1,n_array)))+stand_mean;
s_hat.stand_mean = stand_mean;
s_hat.var_pooled = var_pooled;
s_hat.batches = batches;
s_hat.n_batch = n_batch;
s_hat.n_batches = n_batches;
s_hat.n_array = n_array;
s_hat.design = design;
s_hat.gamma_star = gamma_star;
s_hat.delta_star = delta_star;
% s_data = (dat-stand_mean)./(sqrt(var_pooled)*repmat(1,1,n_array));
end

