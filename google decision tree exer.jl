using ScikitLearn
using DecisionTree
using ScikitLearn
using PyCall
using PyPlot
using ScikitLearn.CrossValidation: train_test_split
using DataFrames
using ScikitLearn.Utils: meshgrid

#using ScikitLearn.Models: DecisionTreeClassifier, RandomForestClassifier, AdaBoostStumpClassifier
@pyimport matplotlib.colors as mplc
@sk_import preprocessing: StandardScaler
@sk_import datasets: (make_moons, make_circles, make_classification)
@sk_import neighbors: KNeighborsClassifier
@sk_import svm: SVC
@sk_import naive_bayes: GaussianNB
@sk_import lda: LDA
@sk_import qda: QDA

h = .02  # step size in the mesh

df = readtable("Speed Dating Data.csv")
#get rid of NAs replace with mean
df[isna(df[:attr]),:attr] = mean(dropna(df[:attr]))
df[isna(df[:sinc]),:sinc] = mean(dropna(df[:sinc]))
df[isna(df[:intel]),:intel] = mean(dropna(df[:intel]))
df[isna(df[:fun]),:fun] = mean(dropna(df[:fun]))
df[isna(df[:amb]),:amb] = mean(dropna(df[:amb]))
df[isna(df[:shar]),:shar] = mean(dropna(df[:shar]))
df[isna(df[:prob]),:prob] = mean(dropna(df[:prob]))

features = DataArray(df[[:attr, :sinc, :intel, :fun, :amb, :shar]])
labels = DataArray(df[:dec_o])

Xa = convert(Array, features)
ya = convert(Vector, labels)
data = [(Xa, ya)]
names = [ "SVC linear", "SVC, ""RBF SVM", "Decision Tree (Julia)",
         "Random Forest (Julia)", "AdaBoost (Julia)", "Naive Bayes", "Linear Discriminant Analysis",
         "Quadratic Discriminant Analysis"]


classifiers = [
    SVC(kernel="linear", C=0.025),SVC(gamma=2, C=1),
    DecisionTreeClassifier(pruning_purity_threshold=0.8),
    RandomForestClassifier(ntrees=20),
    # Note: scikit-learn's adaboostclassifier is better than DecisionTree.jl in this instance
    # because it's not restricted to stumps, and the data isn't axis-aligned
    AdaBoostStumpClassifier(niterations=30),
    GaussianNB(),
    LDA(),
    QDA()]

# X, y = make_classification(n_features=2, n_redundant=0, n_informative=2,
                           #random_state=1, n_clusters_per_class=1)

# srand(42)
# X += 2 * rand(size(X)...)
# linearly_separable = (X, y)

# datasets = [make_moons(noise=0.3, random_state=0),
#     make_circles(noise=0.2, factor=0.5, random_state=1),
#     linearly_separable
#     ];
[make_moons(noise=0.3, random_state=0)]
datasets = data


fig = figure(figsize=(27, 9))
i = 1

# function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T})
#     m, n = length(vy), length(vx)
#     vx = reshape(vx, 1, n)
#     vy = reshape(vy, m, 1)
#     (repmat(vx, m, 1), repmat(vy, 1, n))
# end
#
# function meshgrid{T}(vx::AbstractVector{T}, vy::AbstractVector{T},
#                      vz::AbstractVector{T})
#     m, n, o = length(vy), length(vx), length(vz)
#     vx = reshape(vx, 1, n, 1)
#     vy = reshape(vy, m, 1, 1)
#     vz = reshape(vz, 1, 1, o)
#     om = ones(Int, m)
#     on = ones(Int, n)
#     oo = ones(Int, o)
#     (vx[om, :, oo], vy[:, on, oo], vz[om, on, :])
# end

for ds in datasets
    # preprocess dataset, split into training and test part
    X, y = ds

    X = fit_transform!(StandardScaler(), X)

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.4)

    x_min, x_max = minimum(X[:, 1]) - .5, maximum(X[:, 1]) + .5
    y_min, y_max = minimum(X[:, 2]) - .5, maximum(X[:, 2]) + .5
    xx, yy = meshgrid(x_min:h:x_max, y_min:h:y_max)
    # just plot the dataset first
    cm = PyPlot.cm[:RdBu]
    cm_bright = mplc.ListedColormap(["#FF0000", "#0000FF"])
    ax = subplot(length(datasets), length(classifiers) + 1, i)
    # Plot the training points
    ax[:scatter](X_train[:, 1], X_train[:, 2], c=y_train, cmap=cm_bright)
    # and testing points
    ax[:scatter](X_test[:, 1], X_test[:, 2], c=y_test, cmap=cm_bright, alpha=0.6)

    ax[:set_xlim](minimum(xx), maximum(xx))
    ax[:set_ylim](minimum(yy), maximum(yy))
    ax[:set_xticks](())
    ax[:set_yticks](())
    i += 1


    # iterate over classifiers
    for (name, clf) in zip(names, classifiers)
        ax = subplot(length(datasets), length(classifiers) + 1, i)
        ScikitLearn.fit!(clf, X_train, y_train)
        scor = score(clf, X_test, y_test)
        println(name, clf)

        # Plot the decision boundary. For that, we will assign a color to each
        # point in the mesh [x_min, m_max]x[y_min, y_max].
        try
        # Not implemented for some
         Z = decision_function(clf, hcat(xx[:], yy[:]))
        catch
          Z = predict_proba(clf, hcat(xx[:], yy[:]))[:, 2]
        end

        # Put the result into a color plot
        Z = reshape(Z, size(xx)...)
        ax[:contourf](xx, yy, Z, cmap=cm, alpha=.8)

        # Plot also the training points
        ax[:scatter](X_train[:, 1], X_train[:, 2], c=y_train, cmap=cm_bright)
        # and testing points
        ax[:scatter](X_test[:, 1], X_test[:, 2], c=y_test, cmap=cm_bright,
                   alpha=0.6)

        ax[:set_xlim](minimum(xx), maximum(xx))
        ax[:set_ylim](minimum(yy), maximum(yy))
        ax[:set_xticks](())
        ax[:set_yticks](())
        ax[:set_title](name)

        ax[:text](maximum(xx) - .3, minimum(yy) + .3, @sprintf("%.2f", scor),
                size=15, horizontalalignment="right")
        i += 1
    end
end
fig[:subplots_adjust](left=.02, right=.98)

?predict_proba
