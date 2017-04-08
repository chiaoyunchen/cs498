%%
% 1) EM Topic models The UCI Machine Learning dataset repository hosts 
%   several datasets recording word counts for documents here. You will use
%   the NIPS dataset. You will find (a) a table of word counts per document
%   and (b) a vocabulary list for this dataset at the link. You must
%   implement the multinomial mixture of topics model, lectured in class.
%   For this problem, you should write the clustering code yourself (i.e. 
%   not use a package for clustering).

clc; clear; close all;
data = load('docword.nips.txt');
num_docs  = data(1,1);
num_words = data(1,2);

docs_2d = zeros(num_docs, num_words);
for idx = 2:length(data)
    datum = data(idx,:);
    docs_2d(datum(1), datum(2)) = datum(3);
end
sparse_docs = sparse(docs_2d);

num_topics = 30;
topics = rand(num_topics, num_words);
magnitude = sum(topics, 2);
for idx = 1:num_topics
    topics(idx, :) = topics(idx, :) / magnitude(idx);
end

pis = rand(num_topics, 1);
magnitude = sum(pis, 1);
pis = pis ./ magnitude;

clear data datum documents_2d idx magnitude;

%%
% a) Cluster this to 30 topics, using a simple mixture of multinomial topic
%   model, as lectured in class.

num_steps = 50;
w_per_doc = zeros(num_topics, num_docs);

w_per_doc_m_doc = zeros(num_topics, num_docs, num_words);

for step = 1:num_steps
    step
    for idx = 1:num_docs
        doc = sparse_docs(idx, :);
        w_per_doc(:, idx) = w_from(doc, topics, pis);
        w_per_doc_m_doc(:, idx, :) = w_per_doc(:, idx) * doc;
    end
    
    pis = sum(w_per_doc, 2) / num_docs;
    topics = squeeze(sum(w_per_doc_m_doc, 2));
    magnitude = sum(topics, 2);
    for idx = 1:num_topics
        topics(idx, :) = topics(idx, :) / magnitude(idx);
    end

end

'done'
%%
% b) Produce a graph showing, for each topic, the probability with which
%   the topic is selected.
figure;
stem(pis);
title('Probability vs Topic');
ylabel('Probability of Selection');
xlabel('Topic Number');

%%
% c) Produce a table showing, for each topic, the 10 words with the highest
%   probability for that topic.

vocab = importdata('vocab.nips.txt');

for idx = 1:length(topics(:, 1))
    topic = topics(idx, :);
    idx
    [~,indices] = sort(topic,'descend');
    vocab(indices(1:10))
end






