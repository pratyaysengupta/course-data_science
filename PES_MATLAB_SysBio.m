% MATLAB SysBio Tutorial

%% Making your own model

% Define reaction formulas
ReactionFormulas = {'glc_D[e] -> glc_D[c]',...
'glc_D[c] + atp[c] -> h[c] + adp[c] + g6p[c]',...
'g6p[c] <=> f6p[c]',...
'atp[c] + f6p[c] -> h[c] + adp[c] + fdp[c]',...
'fdp[c] + h2o[c] -> f6p[c] + pi[c]',...
'fdp[c] -> g3p[c] + dhap[c]',...
'dhap[c] -> g3p[c]'};

% Define reaction names
ReactionNames = {'GLCt1r', 'HEX1', 'PGI', 'PFK', 'FBP', 'FBA', 'TPI'};

% Define lower and upper bounds for reactions
lowerbounds = [-20, 0, -20, 0, 0, -20, -20];
upperbounds = [20, 20, 20, 20, 20, 20, 20];

% Create the model
model = createModel(ReactionNames, ReactionNames, ReactionFormulas,...
    'lowerBoundList', lowerbounds, 'upperBoundList', upperbounds);

% Display stoichiometry matrix, metabolites, and reactions
full(model.S)
model.mets
model.rxns

% Display array with reaction names and flux bounds
[{'Reaction ID', 'Lower Bound', 'Upper Bound'};...
model.rxns, num2cell(model.lb), num2cell(model.ub)]

% Display flux bounds using a convenience function
printFluxBounds(model);

% Determine the length of metabolites and reactions
mets_length = length(model.mets)
rxns_length = length(model.rxns)

% Adding reactions
model = addReaction(model, 'GAPDH',...
'reactionFormula', 'g3p[c] + nad[c] + 2 pi[c] -> nadh[c] + h[c] + 13bpg[c]');
model = addReaction(model, 'PGK',...
'reactionFormula', '13bpg[c] + adp[c] -> atp[c] + 3pg[c]');
model = addReaction(model, 'PGM', 'reactionFormula', '3pg[c] <=> 2pg[c]' );

% Display stoichiometry matrix after adding reactions
full(model.S)

% Find reaction IDs
rxnID = findRxnIDs(model, model.rxns)
model.rxns

% Move a reaction
model = moveRxn(model, 8, 1)
model.rxns

% Add exchange reaction for glucose
model = addReaction(model, 'EX_glc_D[e]', 'metaboliteList', {'glc_D[e]'} ,...
'stoichCoeffList', [-1]);

% Determine exchange and uptake reactions
[selExc, selUpt] = findExcRxns(model, 0, 1)

% Add exchange and sink reactions
model = addExchangeRxn(model, {'glc_D[e]', 'glc_D[c]'});
model = addSinkReactions(model, {'13bpg[c]', 'nad[c]'});
model = addDemandReaction(model, {'dhap[c]', 'g3p[c]'});

% Add ratio reaction and change its bounds
model = addRatioReaction(model, {'EX_glc_D[c]', 'EX_glc_D[e]'}, [1; 2]);
model = changeRxnBounds(model, 'EX_glc_D[e]', -18.5, 'l');

% Remove specified reactions
model = removeRxns(model, {'EX_glc_D[c]', 'EX_glc_D[e]', 'sink_13bpg[c]', ...
'sink_nad[c]', 'DM_dhap[c]', 'DM_g3p[c]'});
assert(rxns_length + 3 == length(model.rxns));

% Remove specified metabolites
model = removeMetabolites(model, {'3pg[c]', '2pg[c]'}, false);
printRxnFormula(model, 'rxnAbbrList', {'GAPDH'}, 'gprFlag', true);

% Remove trivial stoichiometry
model = removeTrivialStoichiometry(model);

% Change objective function
modelNew = changeObjective(model, 'GLCt1r', 0.5);
modelNew = changeObjective(model, {'PGI'; 'PFK'; 'FBP'});

% Change gene association
model = changeGeneAssociation(model, 'HEX1', '(G1) or (G2)');

% Store gene association, clear gene-related fields, and update gene association
storeGPR = model.grRules;
model.rxnGeneMat = []
model.genes = []
for i = 1 : length(model.rxns)
    model = changeGeneAssociation(model, model.rxns{i}, storeGPR{i});
end

%% Loading a model

% Load pre-existing model
load ecoli_core_model.mat
help optimizeCbModel

% Optimize the loaded model
sol = optimizeCbModel(model)
find(findExcRxns(model))
model.rxns(find(findExcRxns(model)))

% Display lower and upper bounds of exchange reactions
model.lb(findExcRxns(model))
model.ub(findExcRxns(model))

% Find index of specified lower bound
find(model.lb==-10)
model.rxns(28)

% Change lower bound of a reaction and optimize the model
model.lb(28)=-20
sol = optimizeCbModel(model)

model.lb(28)=-200
sol = optimizeCbModel(model)

model.lb(28)=0
sol = optimizeCbModel(model)

% Optimize the model for different growth conditions
grRate = [];
rates = [-1500 -1000 -500 -200 -50 -20 -10]
for gc = rates
    model.lb(28) = gc;
    sol = optimizeCbModel(model);
    grRate = [grRate; sol.f];
end
plot(-rates,grRate)

% O2 change
model.rxns(36)
model.lb(36)

% Find index of biomass reaction
find(model.c)
model.rxns(13)

% Display formula of a specified reaction
printRxnFormula(model,model.rxns(13))

% Display the stoichiometry of a specified reaction
model.S(:,28)

% Perform single gene deletion analysis
[grRatio, grRatioKO, grRatioWT, delRXns, hasEffect] = singleGeneDeletion(model);
% Determine lethality threshold
hist(grRatio)

%% Downloading the model file

% Define file name and download URL
fileName = 'model.xml';
url = 'http://bigg.ucsd.edu/static/models/iAF1260.xml';
modelPath = websave(fileName, url);

% Load the downloaded model
model = readCbModel(modelPath);

% Perform single gene deletion analysis
[grRatio, grRateKO, grRateWT, hasEffect, delRxns, fluxSolution] = singleGeneDeletion(model);

% Determine number of essential genes
sum(grRatio < 0.05*grRateWT)

% Perform single reaction deletion analysis
[grRatio, grRateKO, grRateWT, hasEffect, delRxn, fluxSolution] = singleRxnDeletion(model);

% Determine number of essential reactions
sum(delRxns)