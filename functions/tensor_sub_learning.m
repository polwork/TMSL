function [Wi,index] = tensor_sub_learning(Y3d, par)

uGrpPatchs = Im2Patch3D(Y3d,par);                   
YClusters = ReshapeTo2D_C(uGrpPatchs);
n = par.nCluster;
index = cell(1,n);
 a=1;
 flag = 0;
while(a==1)
  flag = flag+1;
  label = kmeansPlus(YClusters,n); 
for ii=1:n
    index{ii}=find(label==ii);
    if size(index{ii},2)==1
        a=1;
    break
    else
        a=0;
    end
end
end

Groups = cell(1,n);
Wi = cell(1,n);

for i = 1:n
    index{i}=find(label==i);
    Groups{i} = uGrpPatchs(:,:,index{i});
end
parfor i = 1:n
% [Wi{i},~,~,~ ] =
% Tensor_LRR(permute(Groups{i},[2,1,3]),permute(Groups{i},[2,1,3]),800,1,par.lambda);%%can handle noisy cases,but long time
Wi{i} = Tensor_LRR_closed(permute(Groups{i},[2,1,3]),0.00001);%cannot handle noisy cases,but highly efficient
end

