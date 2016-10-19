using ScikitLearn
using PyCall
using ScikitLearn.CrossValidation: train_test_split
using ScikitLearn.CrossValidation: cross_val_score
using DecisionTree
using DataFrames
using MLBase
@sk_import preprocessing: StandardScaler
@sk_import neighbors: KNeighborsClassifier
@sk_import svm: SVC
@sk_import naive_bayes: GaussianNB
@sk_import discriminant_analysis: (LinearDiscriminantAnalysis, QuadraticDiscriminantAnalysis)


names = ["NearestNeighbors", "LinearSVM", "RBFSVM", "DecisionTree",
         "RandomForest", "NaiveBayes", "LinearDiscriminantAnalysis",
         "QuadraticDiscriminantAnalysis"]



classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025, probability=true),
    SVC(gamma=2, C=1 , probability=true),
    DecisionTreeClassifier(pruning_purity_threshold=0.8),
    RandomForestClassifier(ntrees=100),
    # Note: scikit-learn's adaboostclassifier is better than DecisionTree.jl in this instance
    # because it's not restricted to stumps, and the data isn't axis-aligned
    GaussianNB(),
    LinearDiscriminantAnalysis(),
    QuadraticDiscriminantAnalysis()
  ]

df = readtable("C:/Users/Jason/Documents/BCBI/Atom/sepsis_imputed.csv")
neg_df = df[df[:Blood_Culture_value] .== 0, :]
pos_df = df[df[:Blood_Culture_value] .== 1, :]

while size(neg_df,1) > 500
  y = size(neg_df, 1)
  x = rand(1:y)
  deleterows!(neg_df, x)
end

all_df = vcat(neg_df, pos_df)


features = DataArray(all_df[[:Age_Yrs, :Gender, :Temp, :Pulse, :Resp, :Bpsys, :Bpdia]])
labels = DataArray(all_df[[:Blood_Culture_value]])
Xa = convert(Array, features)
ya = convert(Array, labels)

y = [x::Int for x in ya]
yaa = convert(Array, y)
data =(Xa, yaa)

X, y = data
X = fit_transform!(StandardScaler(), X)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.3)
y_train = y_train[:,1]
y_test=y_test[:,1]

for (name, clf) in zip(names, classifiers)
  ScikitLearn.fit!(clf, X_train, y_train)
  pred = ScikitLearn.predict(clf, X_test)
  println("$name test")
  prob = predict_proba(clf, X_test)
  pred1 = convert(Array{Int64, 1}, pred)
  rocdf = DataFrame(hcat(y_test, pred1 , prob[:,2]))
  scor = score(clf, X_test, y_test)
  println("$name score $scor")
  writetable("C:/Users/Jason/Documents/BCBI/Atom/ROC500/$name.csv", rocdf)
end
