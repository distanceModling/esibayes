function mmsodaCreateMakefile(varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCreateMakeFile.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
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



if nargin==0
    if mmsodaHostnameReturnsLisa()
        mmsodaDir = mmsodaroot;
        disp(['I don''t see any input argument. I''ll assume you want to use the MMSODA Toolbox from this ',10,...
              'location I found on the MATLAB path: ',10,'"',mmsodaDir,'".'])
    else
        warning('Unable to create the Makefile. On the Lisa cluster, where is the MMSODA toolbox located?')
        return
    end
elseif nargin ==1
    mmsodaDir = varargin{1};
    if mmsodaDir(end) ~= '/'
        mmsodaDir = [mmsodaDir,'/'];
    end
    disp(['Using the MMSODA Toolbox from this location: ',10,'"',mmsodaDir,'".'])
else
    error('Function takes only one argument.')
end


source = fullfile(mmsodaroot,'comms','Makefile.template');
destination = 'Makefile';

disp('Creating Makefile...')


makefileStr = '';
fid = fopen(source,'rt');
while true
    tline = fgets(fid);
    if ~ischar(tline)
        break
    end
    makefileStr = [makefileStr,tline];
end
fclose(fid);


fid = fopen(destination,'wt');
fprintf(fid,'%s',sprintf(makefileStr,mmsodaDir));
fclose(fid);



disp('Creating Makefile...Done.')
