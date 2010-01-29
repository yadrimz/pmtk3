function logp = mvnLogprob(X, mu, Sigma)
% Multivariate Gaussian distribution, log pdf
% X(i,:) is i'th case
warning('Use gaussLogpdf instead of mvnLogprob for consistency');
d = size(X,2);
XC = bsxfun(@minus,X,rowvec(mu));
logp = -0.5*sum((XC*inv(Sigma)).*XC,2); %#ok
logZ = (d/2)*log(2*pi) + 0.5*logdet(Sigma);
logp = logp - logZ;
        
if 0
  logp2 = log(mvnpdf(X, rowvec(mu), Sigma));
  assert(approxeq(logp, logp2))
end
