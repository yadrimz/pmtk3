function [z, pz] = mixDiscretePredict(model, X)
% z(i) = argmax_k p(z=k|X(i,:), model)
% pz(i,k) = p(z=k|X(i,:), model)

    [logp, logPz] = mixDiscreteLogprob(model, X); %#ok
    z = maxidx(logPz, [], 2);
    if nargout > 1
        pz = exp(normalizeLogSpace(logPz));
    end    
end