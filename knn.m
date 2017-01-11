

classdef knn
    
    properties
        data
        labels
    end
    
    methods
        function newKnn = knn(X, Y)
            newKnn.data = X;
            newKnn.labels = Y;        
        end
        
        function [labeled] = predict(thisKnn, unlabeled, k)
            %
            [rows , ~] = size(unlabeled);    
            labeled = thisKnn.labels(1:rows);

            for i = 1:rows
                % euclidian distance
                dists = sqrt(sum((thisKnn.data - unlabeled(i, :)).^2 , 2));
                % sort and take k neighbours
                [~ , inds] = sort(dists);
                inds = inds(1:k);
                
                % check the labels
                predicted = thisKnn.labels(inds);
                labeled(i) = mode(predicted);         
            end        
            disp('end');
            
        end
    end
end
