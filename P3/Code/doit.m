
dataPath = '../data/cifar/cifar-10-batches-mat/data_batch_1';
words_per_image = 10;
word_size = 25;
num_words = 30;

dataFile = load(dataPath);
data = dataFile.data;
labels = dataFile.labels;
num_classes = numel(unique(labels));
[m, ~] = size(data);

%words = zeros(words_per_image*m, word_size);
words = [];
word_labels = [];

% collect words from all images in the set
fprintf('Find words');
tic
for i = 1:m
    I = GetImg(data(i,:), labels(i,:), {'a','b','c','d','e','f','g'}, false);
    G = im2double(rgb2gray(I));
    [P, D] = getCorners(G, words_per_image);
    [num_corners, ~] = size(D);
    % Add 10 examples to the the bag of words
    %idx_start = ((i-1)*words_per_image)+1;
    %idx_end = idx_start+words_per_image-1;
    %words(idx_start:idx_end, :) = D;
    words = [words;D];
    word_labels = [word_labels; ones(num_corners, 1).*i];
end
toc

fprintf('K-means');
tic
[~, word_clusters] = kmeans(words, num_words);
toc

fprintf('Histograms');
tic
word_hist = zeros(m, num_words);
for i = 1:m
    %idx_start = ((i-1)*words_per_image)+1;
    %idx_end = idx_start+words_per_image-1;
    %words_i = words(idx_start:idx_end, :);
    words_i = words(word_labels==i, :);
    [count_i, ~] = size(words_i);
    
    hist_i = zeros(count_i, num_words);
    c = clusterNearestNeighbor(word_clusters, words_i);
    hist_i(sub2ind(size(hist_i), 1:count_i, c')) = 1;
    word_hist(i, :) = sum(hist_i);
end
toc


fprintf('SVM Train');
tic
for i = 1:num_classes
    labels_i = (labels(1:m)==i);
    model = fitcsvm(word_hist, labels_i);
    p = model.predict(word_hist(1:m,:));
    a = labels_i(1:m);
    sum(abs(p-a))
end
toc

%imshow(I); hold on;
%plot(P(:,1), P(:,2), '+');

hold off;