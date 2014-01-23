function mmsodaWriteJobscript()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaWriteJobscript.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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
mpiModuleStr = 'openmpi/gnu/1.6.5';
mcrModuleStr = 'mcr/v81'; %(2013a)

templateInteractiveOnLogin = [...
'echo ',char(34),'Unloading module matlab',char(34),char(10),...
'module unload matlab',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Loading module ',mpiModuleStr,char(34),char(10),...
'module load ',mpiModuleStr,char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Loading module ',mcrModuleStr,char(34),'',char(10),...
'module load ',mcrModuleStr,char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Starting MPI job on node ',char(34),'`hostname`',char(10),...
'ncpus=`cat /proc/cpuinfo | grep processor | wc -l`',char(10),...
'((nprocs=%s))',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'I detected that ',char(34),'`hostname`',char(34),' has ',...
char(34),'$ncpus',char(34),' processors. I',char(39),'ll start ',char(34),...
'$(($nprocs+1))',char(34),' processes.',char(34),'',char(10),...
'echo',char(10),...
'echo ',char(34),'Adding the current workdir to the library path environment variable',char(34),char(10),...
'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PBS_O_WORKDIR',char(10),...
'echo',char(10),...
'echo ',char(34),'The current LD_LIBRARY_PATH is:',char(34),'',char(10),...
'echo $LD_LIBRARY_PATH',char(10),...
'echo',char(10),...
'echo ',char(34),'Result of ',char(39),'ldd matlabprog',char(39),' is:',char(34),char(10),...
'ldd matlabprog',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'nm matlabprog',char(39),' is:',char(34),char(10),...
'nm matlabprog',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'ldd libmmpi.so',char(39),' is:',char(34),char(10),...
'ldd libmmpi.so',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'nm libmmpi.so',char(39),' is:',char(34),char(10),...
'nm libmmpi.so',char(10),...
'echo',char(10),...
char(10),...
'module list 2>&1',char(10),...
char(10),...'mcrFolderName=`mktemp -d /scratch/mmsoda-XXXXXXXX`',char(10),...
'echo ',char(34),'Setting MCR_CACHE_ROOT to: $mcrFolderName',char(34),char(10),...
'export MCR_CACHE_ROOT=$mcrFolderName',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'The current MCR_CACHE_ROOT is:',char(34),'',char(10),...
'echo $MCR_CACHE_ROOT',char(10),...
'echo',char(10),...
char(10),...
'echo',char(10),...
'echo ---------------------------------------------------',char(10),...
'echo "The environment variables are (env|sort)"',char(10),...
'env|sort',char(10),...
'echo ---------------------------------------------------',char(10),...
'echo',char(10),...
'echo ',char(34),'Starting MPI run',char(34),'',char(10),...
'echo',char(10),...
char(10),...
'mpirun -n $(($nprocs+1)) ./matlabprog -v %d %s',char(10),...
];



templatePBS = [...
'echo ',char(39),'Current dir ($PWD) is:',char(39),char(10),...
'echo $PWD',char(10),...
'echo ',char(39),'Changing into $PBS_O_WORKDIR',char(39),char(10),...
'cd $PBS_O_WORKDIR',char(10),...
'echo ',char(39),'Current dir is ($PWD):',char(39),char(10),...
'echo $PWD',char(10),...
'echo "Result of ',char(39),'ls -l',char(39),' is:"',char(10),...
'ls -l',char(10),...
'echo ',char(34),'Unloading module matlab',char(34),char(10),...
'module unload matlab',char(10),...
'echo',char(10),...
'echo ',char(34),'Loading module ',mpiModuleStr,char(34),char(10),...
'module load ',mpiModuleStr,char(10),...
'echo',char(10),...
'echo ',char(34),'Loading module ',mcrModuleStr,char(34),char(10),...
'module load ',mcrModuleStr,char(10),...
'echo',char(10),...
'echo ',char(34),'Starting MPI job on node ',char(34),'`hostname`',char(10),...
'nnodes=$PBS_NUM_NODES',char(10),...
'nprocs=0',char(10),...
'for nodename in `cat $PBS_NODEFILE`',char(10),...
'do',char(10),...
'    ncpus=`ssh $nodename ',char(39),'cat /proc/cpuinfo | grep processor | wc -l',char(39),'`',char(10),...
'    echo ',char(34),'node ',char(34),'$nodename',char(34),' has ',char(34),'$ncpus',char(34),' CPUs.',char(34),char(10),...
'    for i in `seq 1 $ncpus`; do',char(10),...
'        echo $nodename >> $TMPDIR/myhostfile',char(10),...
'    done',char(10),...
'    ((nprocs=$nprocs+$ncpus))',char(10),...
'done',char(10),...
'echo ',char(34),'Starting interactive MPI job on ',char(34),'$nnodes',char(34),...
' batch nodes with a total of ',char(34),'$nprocs',char(34),' CPUs.',char(34),char(10),...
'cat $TMPDIR/myhostfile',char(10),...
'echo',char(10),...
'echo ',char(34),'Adding the current workdir to the library path environment variable',char(34),char(10),...
'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PBS_O_WORKDIR',char(10),...
'echo',char(10),...
'echo ',char(34),'The current LD_LIBRARY_PATH is:',char(34),'',char(10),...
'echo $LD_LIBRARY_PATH',char(10),...
'echo',char(10),...
'echo ',char(34),'Result of ',char(39),'ldd matlabprog',char(39),' is:',char(34),char(10),...
'ldd matlabprog',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'nm matlabprog',char(39),' is:',char(34),char(10),...
'nm matlabprog',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'ldd libmmpi.so',char(39),' is:',char(34),char(10),...
'ldd libmmpi.so',char(10),...
'echo',char(10),...
char(10),...
'echo ',char(34),'Result of ',char(39),'nm libmmpi.so',char(39),' is:',char(34),char(10),...
'nm libmmpi.so',char(10),...
'echo',char(10),...
char(10),...
'module list 2>&1',char(10),...
char(10),...
'mcrFolderName=`mktemp -d /scratch/mmsoda-XXXXXXXX`',char(10),...
'echo ',char(34),'Setting MCR_CACHE_ROOT to: $mcrFolderName',char(34),char(10),...
'export MCR_CACHE_ROOT=$mcrFolderName',char(10),...
'echo',char(10),...
'echo ',char(34),'The current MCR_CACHE_ROOT is:',char(34),'',char(10),...
'echo $MCR_CACHE_ROOT',char(10),...
'echo',char(10),...
char(10),...
'echo',char(10),...
'echo ---------------------------------------------------',char(10),...
'echo "The environment variables are (env|sort)"',char(10),...
'env|sort',char(10),...
'echo ---------------------------------------------------',char(10),...
'echo',char(10),...
'echo',char(10),...
'echo ',char(34),'Starting MPI run',char(34),'',char(10),...
'mpirun -n $(($nprocs+1)) -hostfile $TMPDIR/myhostfile $PBS_O_WORKDIR/matlabprog -v %d %s',char(10),...
];




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q1.s = ['Will you run your optimization...',char(10),...
    '[a]: interactively as a shell script on one of the login nodes;',char(10),...
    ' b : interactively as a shell script through the "qsub" command;',char(10),...
    ' c : as a PBS jobscript;',char(10),...
    ' d : cancel.',char(10),...
    char(10),...
    'Your answer: '];
q1.validset = {'a','b','c','d',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q2.s = ['How many nodes do you need?',char(10),...
    'Your answer: '];
q2.validset = {};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q3.s = ['How much walltime do you need? (HH:mm:ss)',char(10),...
    'Your answer: '];
q3.validset = {};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q4.s = ['How much verbal feedback do you want from the program?',char(10),...
    '[a]: not much;',char(10),...
    ' b : intermediate;',char(10),...
    ' c : a lot;',char(10),...
    ' d : I want to know everything;',char(10),...
    ' e : cancel.',char(10),...
    char(10),...
    'Your answer: '];
q4.validset = {'a','b','c','d','e',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% q5.s = ['Do you want to use a non-default value for MPI_BUFFER_SIZE?',char(10),...
%     ' a : yes;',char(10),...
%     '[b]: no;',char(10),...
%     ' c : cancel',char(10),...
%     char(10),...
%     'Your answer: '];
% q5.validset = {'a','b','c',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% q6.s = ['Set the non-default value for MPI_BUFFER_SIZE (positive integer)',char(10),...
%     char(10),...
%     'Your answer: '];
% q6.validset = {};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q7.s = ['Would you like to leave some cores unused (to keep the sys admins happy)',char(10),...
    '[a]: yes;',char(10),...
    ' b : no;',char(10),...
    ' c : cancel',char(10),...
    char(10),...
    'Your answer: '];
q7.validset = {'a','b','c',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q8.s = ['How many worker processes would you like to start?',char(10),...
    char(10),...
    'Your answer: '];
q8.validset = {};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q9.s = ['Would you like to save the timings?',char(10),...
    ' a : yes;',char(10),...
    '[b]: no;',char(10),...
    ' c : cancel.',char(10),...
    char(10),...
    'Your answer: '];
q9.validset = {'a','b','c',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

a1 = ask(q1);
switch a1
    case {'a',''}
        if strcmp(a1,'')
            fprintf(1,'\b%c\n','a')
        end
        runAsShellScript = true;
        runThroughQSub = false;
        filename = 'run-mmsoda.sh';
        pbsHeaderStr = '';
    case 'b'
        runAsShellScript = true;
        runThroughQSub = true;
        filename = 'run-mmsoda.sh';
        pbsHeaderStr = '';
    case 'c'
        runAsShellScript = false;
        runThroughQSub = true;
        filename = 'jobscript-mmsoda.pbs';
    case 'd'
        disp('Aborting.')
        return
end
clear q1
clear a1
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


a4 = ask(q4);
switch a4
    case {'a',''}
        if strcmp(a4,'')
            fprintf(1,'\b%c\n','a')
        end
        verbosity = 0;
    case 'b'
        verbosity = 1;
    case 'c'
        verbosity = 2;
    case 'd'
        verbosity = 3;
    case 'e'
        disp('Aborting.')        
        return
end
clear a4
clear q4

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% a5 = ask(q5);
% switch a5
%     case 'a'
%         a6 = ask(q6,'replyMustBeInteger',true);
%         mpiBuffSize = str2double(a6);
%         clear q6
%         clear a6
%     case {'b',''}
%         if strcmp(a5,'')
%             fprintf(1,'\b%c\n','b')
%         end
%         mpiBuffSize = mpiBuffSizeDefault;
%     case 'c'
%         disp('Aborting.')        
%         return
% end
% clear a5
% clear q5
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

if runAsShellScript && ~runThroughQSub
    a7 = ask(q7);
    switch a7
        case {'a',''}
            if strcmp(a7,'')
                fprintf(1,'\b%c\n','a')
            end
            a8 = ask(q8,'replyMustBeInteger',true);
            nProcsStr = a8;
            clear q8
            clear a8
        case 'b'
            nProcsStr = '$ncpus';
            disp('not implemented')
        case 'c'
            disp('Aborting.')        
            return
    end
    clear a5
    clear q5
end



if ~runAsShellScript && runThroughQSub

    a2 = ask(q2,'replyMustBeInteger',true);
    nNodes = str2double(a2);
    clear q2
    clear a2

    a3 = ask(q3,'replyMustBeStr',true,'assumeValid',true);
    if ~isempty(strfind(a3,':'))
        if numel(a3)==8
            wallTimeStr = a3;
        elseif numel(a3)==5
            wallTimeStr = ['00:',a3];
        else
            error('Unknown time format.')
        end
    else
        a3 = strrep(a3,'d','d,');
        a3 = strrep(a3,'h','h,');
        a3 = strrep(a3,'m','m,');
        nums = textscan(a3,'%u16%c','Delimiter',',');
        if numel(nums{1})~=numel(nums{2})
            error('Unknown time format.')
        end
        
        nums4 = zeros(4,1);
        nums4Str = 'dhms';
        for iNum4=1:4
            ix = find(nums{2}==nums4Str(iNum4));
            if numel(ix)==1
                nums4(iNum4,1) = nums{1}(ix);
            elseif numel(ix)>1
                error('Unknown number format.')
            else
            end
        end
        nHours = nums4(1,1)*24 + nums4(2,1);
        nMinutes = nums4(3,1);
        nSeconds = nums4(4,1);
        
        wallTimeStr = sprintf('%d:%02d:%02d',nHours,nMinutes,nSeconds);
        
    end
    clear q3
    clear a3
    clear nums
    clear iNum4
    clear ix
    clear nums4
    clear nHours
    clear nMinutes
    clear nSeconds

    pbsHeaderStr = sprintf(['#!/bin/bash',char(10),...
                   '#',char(10),...
                   '#PBS -lwalltime=%s',char(10),...
                   '#PBS -lnodes=%d',char(10),...
                   '#PBS -o results/',char(10),...
                   '#PBS -e results/' ,char(10)],wallTimeStr,nNodes);


end


a9 = ask(q9);
switch a9
    case 'a'
        saveTimingsStr = '-t';
    case {'b',''}
        if strcmp(a9,'')
            fprintf(1,'\b%c\n','b')
        end
        saveTimingsStr = '';
    case 'c'
        disp('Aborting.')
        return
end
clear q1
clear a1
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

disp(['Writing ',char(39),filename,char(39),' to ',pwd])
fid = fopen(filename,'wt');
if runAsShellScript && ~runThroughQSub
    usageStr = sprintf('\n#Use this script interactively on one of the login nodes by typing ./%s at the LISA prompt.\n\n\n',filename);
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templateInteractiveOnLogin,nProcsStr,verbosity,saveTimingsStr));
    
elseif runAsShellScript && runThroughQSub
    templateInteractiveQSub = templatePBS;
    usageStr = sprintf('\n#Use this script interactively in a qsub session by typing ./%s at the LISA prompt.\n\n\n',filename);
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templateInteractiveQSub,verbosity,saveTimingsStr));
    
elseif ~runAsShellScript && runThroughQSub
    usageStr = sprintf('\n#Submit this script using "qsub %s" at the LISA prompt.\n\n\n',filename);
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templatePBS,verbosity,saveTimingsStr));
    
else
    
end
status = fclose(fid);
disp('Done.')


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % %                                                                 % % %
% % %                    LOCAL FUNCTIONS START HERE                   % % %
% % %                                                                 % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %




function reply = ask(q,varargin)

questionStr = q.s;
validAnswers = q.validset;

assumeValid = false;
replyMustBeInteger = false;
replyMustBeStr = true;

authorizedOptions = {'assumeValid','replyMustBeInteger','replyMustBeStr'};
mmsodaParsePairs()




if ~iscellstr(validAnswers)
    error('Please enter the set of valid answers as a cell of strings.')
end

replyWasValid = false;

while ~replyWasValid
    
    disp(char(9))
    disp(char(9))
    
    reply = input(questionStr,'s');
    
    replyWasValid = assumeValid || ...
        (replyMustBeStr && any(strcmp(reply,validAnswers))) ||...
        (replyMustBeInteger && mod(str2double(reply),1)==0);
    
    if ~replyWasValid
        disp('Your answer is invalid.')
    end        
   
end


function tmpdirStr = generateMCRFolderName()

availChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
nChars = numel(availChars);
tmpdirStr = ['$TMPDIR/','mmsoda_',availChars(randi(nChars,[1,4])),'-',availChars(randi(nChars,[1,4])),'-',...
                                  availChars(randi(nChars,[1,4])),'-',availChars(randi(nChars,[1,4]))];
