% Classify the MNIST digits using a one nearest neighbour classifier
% and Euclidean distance.
%
% Code by Matthew Dunham

clear all
load mnistALL;
if 1
  % test on all data- 255 seconds, 3.09% error
  trainndx = 1:60000; testndx =  1:10000;
else
  % test on subset - 28 seconds, 3.80% error
  trainndx = 1:60000; 
  testndx =  1:1000; 
end
ntrain = length(trainndx);
ntest = length(testndx);
Xtrain = double(reshape(mnist.train_images(:,:,trainndx),28*28,ntrain)');
Xtest  = double(reshape(mnist.test_images(:,:,testndx),28*28,ntest)');

if 1 
  % matrix is real-valued but has many zeros due to black boundary
  % so we make it sparse to save space
  Xtrain = sparse(Xtrain);
  Xtest = sparse(Xtest);
end

ytrain = (mnist.train_labels(trainndx));
ytest  = (mnist.test_labels(testndx));
clear mnist trainndx testndx; % save space

tic
% Precompute sum of squares term for speed
XtrainSOS = sum(Xtrain.^2,2);
XtestSOS  = sum(Xtest.^2,2);

%% fully vectorized solution takes too much memory so we will classify in batches
% nbatches must be an even divisor of ntest, increase if you run out of memory 
if ntest > 1000
  nbatches = 50;
  else
  nbatches = 5;
end
batches = mat2cell(1:ntest,1,(ntest/nbatches)*ones(1,nbatches));
ypred = zeros(ntest,1);
wbar = waitbar(0,sprintf('%d of %d classified',0,ntest));
%% Classify
for i=1:nbatches
    t = toc; waitbar(i/nbatches,wbar,sprintf('%d of %d Classified\nElapsed Time: %.2f seconds',(i-1)*(ntest/nbatches),ntest,t));
    dst = sqDistance(Xtest(batches{i},:),Xtrain,XtestSOS(batches{i},:),XtrainSOS);
    [junk,closest] = min(dst,[],2);
    ypred(batches{i}) = ytrain(closest);
end
%% Report
close(wbar);
errorRate = mean(ypred ~= ytest);
fprintf('Error Rate: %.2f%%\n',100*errorRate);
t = toc; fprintf('Total Time: %.2f seconds\n',t);
