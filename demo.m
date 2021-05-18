clear;close all;
startup; %% setup vlfeat
%% loading data
addpath('./data/');
I1=imread('malaga0192.jpg');  %% Candidate frame
I2=imread('malaga2784.jpg');  %% Query image
load malaga_0192vs2784.mat;   %% The putative set constructed in advance. If not exist, users could create it based on the following codes.

%%%% no initial correspondences
% SiftThreshold = 1.5; % no smaller than 1
% [X, Y] = sift_match(I1, I2, SiftThreshold);

%% parameter setting
K=13;  %% size of neighborhoods
lambda=0.17;  %% inlier threshold
eta=[0.2, 0.5, 0.5]; %% parameters of the filter

%% BMRC
tic;
index = BMRC(X, Y, K, lambda, eta);
toc

%% Evaluation
if ~exist('CorrectIndex', 'var'), CorrectIndex = index; end
[precise, recall, corrRate] = evaluate(CorrectIndex, index, size(X,1));
Fscore=2*precise*recall/(precise+recall)

%% Plot results 
plot_both_row(I1, I2, X, Y, index, CorrectIndex, precise, recall, Fscore);
rmpath('./data/');