function options = setoption(options)
%{
Options:
width: width in each hidden layer
depth: total number of hidden layers
L1: weight-decay/jacobian/L1 penalty
L2: weight-decay penalty
regular: wd(weight decay)/lm(large margin)/
lassolayer: 0/1

prior: if using lm as regularizer, a matrix feature x output dim as
path (1 for exists, 0 for no path)
learningrate: learning rate (no need for rmsprop)
learningdecayrate: learning rate (no need for rmsprop)
activation function: relu,sigmoid,lrelu (leakyrelu)
lrelualpha: leakyrelu alpha for negative part
optimizer: SGD,RMSPROP,ADAGRAD
maxepoch: max epochs
batchsize: 
validationratio : use how many percent samples to validate?
patience : wait how many epochs for a better validatoin result?

verbose : more output?
seed: just some randseed
%}
if nargin<1
    options = [];
end

if ~isfield(options,'width')
    options.width = 20;
end
if ~isfield(options,'depth')
    options.depth = 1;
end
if ~isfield(options,'L1')
    options.L1 = 0;
end
if ~isfield(options,'L2')
    options.L2 = 0;
end
if ~isfield(options,'regular')
    options.regular = 'wd';
end
if ~isfield(options,'dropout')
    options.dropout = 0;
end
if ~isfield(options,'maxnorm')
    options.maxnorm = realmax;
end
if ~isfield(options,'tanhtransform')
    options.tanhtransform = 0;
end
if ~isfield(options,'prior')
    options.prior = 0;
end
if ~isfield(options,'learningrate')
    options.learningrate = 0.001;
end
if ~isfield(options,'learningdecayrate')
    options.learningdecayrate = 1;
end
if ~isfield(options,'activation')
    options.activation = 'tanh';
end
if ~isfield(options,'lrelualpha')
    options.lrelualpha = 1e-2;
end
if ~isfield(options,'optimizer')
    options.optimizer = 'RMSPROP';
end
if ~isfield(options,'maxepoch')
    options.maxepoch = 5000;
end
if ~isfield(options,'validationratio')
    options.validationratio = 0;
end
if ~isfield(options,'patience')
    options.patience = 50;
    % how many epochs?
end
if ~isfield(options,'batchsize')
    options.batchsize = 0;
end
if ~isfield(options,'verbose')
    options.verbose = 0;
end
if ~isfield(options,'connectx')
    options.connectx = 0;
end
if ~isfield(options,'seed')
    options.seed = 1;
end
if ~isfield(options,'initialfit')
    options.initialfit = 0;
end
if ~isfield(options,'glmfilter')
    options.glmfilter = 0;
end
if ~isfield(options,'sparseinit')
    options.sparseinit = 0;
end
if ~isfield(options,'layerwisefinetune')
    options.layerwisefinetune = 0;
end
end