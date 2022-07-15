function [Walks,Degs] = findWalksDegs(Adj,n)
%FINDWALKSDEGS Finds all walks on a graph
%   Finds all walks up to length n on an undirected graph represented by 
%   adjacency matrix Adj. The (i,j,k)th element of Walks is a cell 
%   containing all walks from node i to node j of length k. A walk from 
%   node A to node B to node C (length 2) will be represented by a vector 
%   [A,B,C]. Each element in Walks has a corresponding element in Degs 
%   which contains the degree of each node on the walk.


%Walden Marshall, 7/15/2022

Walks=cell([size(Adj),n]);          %the {i,j,k} element of walks will contain
                                    %a cell with all walks from i to j of
                                    % length k
Degs=cell([size(Adj),n]);
DegAdj=sum(Adj,1);

%find all walks of length 1
[R,C]=find(Adj);
RCL=[R,C,ones(length(R),1)];
for i=1:size(RCL,1)
    locbuf=RCL(i,:);
    Walks{locbuf(1),locbuf(2),locbuf(3)}={RCL(i,1:2)};
    Degs{locbuf(1),locbuf(2),locbuf(3)}={DegAdj(RCL(i,1:2))};
end
for i=1:prod(size(Walks))   %making all the elements empty cells
    if isempty(Walks{i})    %instead of empty arrays
        Walks{i}={};
        Degs{i}={};
    end
end
clear R C RCL locbuf

%find walks of length 2 or more
for i=2:n
    Cxns=~cellfun(@isempty,Walks);
    Cxns=Cxns(:,:,i-1);
    walksbuf=Walks(:,:,i-1);
    Cxns=walksbuf(Cxns);    %list of all connections of length i
                            %sorted by start and end node
    for j=1:length(Cxns)
        CxnSE=Cxns{j};  %all walks of age i with same start and
                        %end node
        for k=1:length(CxnSE)
            Cxn=CxnSE{k};
            if length(Cxn)>4
                disp('')
            end
            firstnode=Cxn(1);
            lastnode=Cxn(end);
            NextNodes=find(Adj(lastnode,:)~=0);
            for l=1:length(NextNodes)
                newCxn=[Cxn,NextNodes(l)];
                walksbuf=Walks{firstnode,NextNodes(l),i};
                walksbuf{end+1}=newCxn;
                Walks{firstnode,NextNodes(l),i}=walksbuf;
                degsbuf=Degs{firstnode,NextNodes(l),i};
                degsbuf{end+1}=DegAdj(newCxn);
                Degs{firstnode,NextNodes(l),i}=degsbuf;
            end  
        end
    end
end

end