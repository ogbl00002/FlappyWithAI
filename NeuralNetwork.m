classdef NeuralNetwork
    properties
        numInputs;
        numHidden;
        numOutputs;
        
        W_ih; % Weights input Layer -> hidden Layer
        W_ho; % Weights hidden Layer -> output Layer

        a;    % Learning Rate
    end
    
    
    methods
        % Initialise the network
        function this = NeuralNetwork(NrInputs,NrHidden,NrOutputs,learningRate)
            this.numInputs = NrInputs;
            this.numHidden = NrHidden;
            this.numOutputs = NrOutputs;
            this.a = learningRate;
            
            this.W_ih = (1/sqrt(NrHidden))*randn(this.numHidden,this.numInputs);
            this.W_ho = (1/sqrt(NrOutputs))*randn(this.numOutputs,this.numHidden);

        end
        
        
        
        
        
        function[this,deltaW_ih,deltaW_ho] =  TrainBrain(this,inputs,targets)
            X_h = this.W_ih*inputs;
            O_h = sigmoid(X_h); % Outputs of hidden layer
            
            X_o = this.W_ho*O_h; 
            O_o = sigmoid(X_o); % Outputs of output layer
            
            error_o = (targets-O_o);
            error_h = this.W_ho'*error_o;
            
            grad1 = error_o.*O_o.*(1-O_o);
            grad2 = error_h.*O_h.*(1-O_h);
            
            
            deltaW_ho = this.a*grad1*O_h';
            deltaW_ih = this.a*grad2*inputs';
                

            
            this.W_ih = this.W_ih + deltaW_ih;
            this.W_ho = this.W_ho + deltaW_ho;
            


            

        end
        
        
        
        function[O_o] =  query(this,inputs)
            X_h = this.W_ih*inputs;
            O_h = sigmoid(X_h);
            
            X_o = this.W_ho*O_h;
            O_o = sigmoid(X_o);
        end
        
        
    end
end