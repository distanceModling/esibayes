function objScore = rmse_flow(conf,constants,modelOutput,parVec)

% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END


mmsodaUnpack()


[nOutputs,nDASteps,nMembers,tmp] = size(modelOutput);

% row of interest in modelOutput is #3
r = 3;

obs = repmat(obsQ(2:nDASteps),[1,1,nMembers]);
sim = modelOutput(r,2:nDASteps,1:nMembers);

nObs = nDASteps-1;

ensembleMeanErr = mean(obs-sim,3);

ssr = sum(ensembleMeanErr.^2);

objScore = (1/2) * nObs * log(ssr);