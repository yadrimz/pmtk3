
% Reproduce table 1 from "Robust statistical modeling using the T
% distribution", Lange et al, JASA 1989
% The estimated coefficients are similar
% However, this does *not* reproduce the log likelihoods correctly
% The reason for this is not clear - is Lange evaluating the expected
% complete data loglik instead?

%PMTKauthor Hannes Bretschneider

load stackloss;
n = size(X,1);
X1 = [ones(n,1) X];
%% fit model
% dof=0 means estimate from data
% dof=100 means effectively use Gaussian model
dofs = [100, 8, 4, 3, 2, 1.1, 1, 0.5, 0];
for i = 1:length(dofs)
  dof = dofs(i);
    modelEM{i} = linregRobustStudentFitEm(X, y, dof);
    loglikEM(i) = sum(linregRobustStudentLogprob(modelEM{i}, X, y));
    
    % debug - use objective fn from linregRobustStudentFitConstr
    sigma2 = modelEM{i}.sigma2; w = [modelEM{i}.w0; modelEM{i}.w]; 
    sigma = sqrt(sigma2);
    theta = y - X1*w;
    nll = sum(1/2*log(dof*pi) + log(gamma(dof/2)) - log(gamma((dof+1)/2)) + ...
      log(sigma) + (dof+1)/2*log(1+theta.^2 / (sigma2*dof)));
    assert(approxeq(nll, -loglikEM(i)))
  
    modelConstr{i} = linregRobustStudentFitConstr(X, y, dof);
    loglikConstr(i) = sum(linregRobustStudentLogprob(modelConstr{i}, X, y));
end

%% format output

fprintf('estimated dof, EM %5.3f, constr %5.3f\n', ...
  modelEM{end}.dof, modelConstr{end}.dof);
ndof = length(dofs);
table = NaN(ndof,6);
table(:,1) = dofs';
table(:,2) = loglikEM';
for i = 1:ndof
    table(i,3:6) = modelEM{i}.w;
end
labels = {'dof', 'loglik', 'w0', 'w1', 'w2', 'w3'};
latextable(table, 'Format', '%5.3f', 'horiz', labels, 'hline', 1, ...
  'name', 'stacklossOutputEm');
table


table = NaN(ndof,6);
table(:,1) = dofs';
table(:,2) = loglikConstr';
for i = 1:ndof
    table(i,3:6) = modelConstr{i}.w;
end
latextable(table, 'Format', '%5.3f', 'horiz', labels, 'hline', 1, ...
  'name', 'stacklossOutputConstr');
table

