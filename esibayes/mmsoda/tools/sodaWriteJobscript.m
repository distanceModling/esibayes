function sodaWriteJobscript()


mpiBuffSizeDefault = 500000000;

mcrFolderName = generateMCRFolderName();


templateInteractiveOnLogin = [...
'echo ',char(34),'unloading module matlab',char(34),char(10),...
'module unload matlab',char(10),...
'echo ',char(34),'loading module openmpi/gnu',char(34),char(10),...
'module load openmpi/gnu',char(10),...
'echo ',char(34),'loading module mcr',char(34),char(10),...
'module load mcr',char(10),...
'echo ',char(34),'Starting MPI job on node ',char(34),'`hostname`',char(10),...
'ncpus=`cat /proc/cpuinfo | grep processor | wc -l`',char(10),...
'((nprocs=%s))',char(10),...
'echo ',char(34),'I detected that ',char(34),'`hostname`',char(34),' has ',char(34),'$ncpus',char(34),' processors. I',char(39),'ll start ',char(34),'$nprocs',char(34),' processes.',char(34),char(10),...
'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.',char(10),...
'echo ',char(34),'making directory:',mcrFolderName,char(34),char(10),...
'mkdir ',mcrFolderName,char(10),...
'echo ',char(34),'setting MCR_CACHE_ROOT to:',mcrFolderName,char(34),char(10),...
'export MCR_CACHE_ROOT=',mcrFolderName,char(10),...
'mpirun -n $nprocs ./matlabprog -v %d -b %d %s',char(10),...
];




templatePBS = [...
'echo ',char(34),'unloading module matlab',char(34),char(10),...
'module unload matlab',char(10),...
'echo',char(10),...
'echo ',char(34),'loading module openmpi/gnu',char(34),char(10),...
'module load openmpi/gnu',char(10),...
'echo',char(10),...
'echo ',char(34),'loading module mcr',char(34),char(10),...
'module load mcr',char(10),...
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
'echo ',char(34),'Starting interactive MPI job on ',char(34),'$nnodes',char(34),' batch nodes with a total of ',char(34),'$nprocs',char(34),' CPUs.',char(34),char(10),...
'cat $TMPDIR/myhostfile',char(10),...
'echo',char(10),...
'echo ',char(34),'adding the current workdir to the library path environment variable',char(34),char(10),...
'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PBS_O_WORKDIR',char(10),...
'echo',char(10),...
'echo ',char(34),'specifying $TMPDIR on scratch as the MCR_CACHE_ROOT dir',char(34),char(10),...
'export MCR_CACHE_ROOT=$TMPDIR',char(10),...
'mpirun -np $nprocs -hostfile $TMPDIR/myhostfile $PBS_O_WORKDIR/matlabprog -v %d -b %d %s',char(10),...
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
q5.s = ['Do you want to use a non-default value for MPI_BUFFER_SIZE?',char(10),...
    ' a : yes;',char(10),...
    '[b]: no;',char(10),...
    ' c : cancel',char(10),...
    char(10),...
    'Your answer: '];
q5.validset = {'a','b','c',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q6.s = ['Set the non-default value for MPI_BUFFER_SIZE (positive integer)',char(10),...
    char(10),...
    'Your answer: '];
q6.validset = {};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q7.s = ['Would you like to leave some cores unused (to keep the sys admins happy)',char(10),...
    '[a]: yes;',char(10),...
    ' b : no;',char(10),...
    ' c : cancel',char(10),...
    char(10),...
    'Your answer: '];
q7.validset = {'a','b','c',''};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
q8.s = ['How many processes would you like to start?',char(10),...
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
a5 = ask(q5);
switch a5
    case 'a'
        a6 = ask(q6,'replyMustBeInteger',true);
        mpiBuffSize = str2double(a6);
        clear q6
        clear a6
    case {'b',''}
        if strcmp(a5,'')
            fprintf(1,'\b%c\n','b')
        end
        mpiBuffSize = mpiBuffSizeDefault;
    case 'c'
        disp('Aborting.')        
        return
end
clear a5
clear q5

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

    a3 = ask(q3,'replyMustBeStr',true);
    wallTimeStr = a3;
    clear q3
    clear a3

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
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templateInteractiveOnLogin,nProcsStr,verbosity,mpiBuffSize,saveTimingsStr));
    
elseif runAsShellScript && runThroughQSub
    templateInteractiveQSub = templatePBS;
    usageStr = sprintf('\n#Use this script interactively in a qsub session by typing ./%s at the LISA prompt.\n\n\n',filename);
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templateInteractiveQSub,verbosity,mpiBuffSize,saveTimingsStr));
    
elseif ~runAsShellScript && runThroughQSub
    usageStr = sprintf('\n#Submit this script using "qsub %s" at the LISA prompt.\n\n\n',filename);
    nChars = fprintf(fid,'%s',pbsHeaderStr,usageStr,sprintf(templatePBS,verbosity,mpiBuffSize,saveTimingsStr));
    
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
sodaParsePairs()




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