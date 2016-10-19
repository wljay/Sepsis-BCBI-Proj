using ScikitLearn
using DecisionTree
using DataFrames
using ScikitLearn.CrossValidation: train_test_split
using ScikitLearn.CrossValidation: cross_val_score
using PyCall
using MLBase
using MLBasePlotting
using Cairo
using Gadfly
@sk_import preprocessing: StandardScaler


df = readtable("C:/Users/Jason/Documents/BCBI/Atom/sepsis_imputed.csv")
neg_df = df[df[:Blood_Culture_value] .== 0, :]
pos_df = df[df[:Blood_Culture_value] .== 1, :]

while size(neg_df,1) > 500
  y = size(neg_df, 1)
  x = rand(1:y)
  deleterows!(neg_df, x)
end

neg_df

all_df = vcat(neg_df, pos_df)


features = DataArray(all_df[[:Age_Yrs, :Gender, :Temp, :Pulse, :Resp, :Bpsys, :Bpdia]])
labels = DataArray(all_df[[:Blood_Culture_value]])
Xa = convert(Array, features)
ya = convert(Array, labels)

y = [x::Int for x in ya]
yaa = convert(Array, y)
data =(Xa, yaa)

clf = RandomForestClassifier(ntrees=100)
X, y = data
X = fit_transform!(StandardScaler(), X)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.3)
y_train = y_train[:,1]

#model = build_forest(X_train, y_train, 3, 1000)


ScikitLearn.fit!(clf, X_train, y_train)
pred = ScikitLearn.predict(clf, X_test)
prob = ScikitLearn.predict_proba(clf, X_test)
#get_classes(clf)
pred1 = convert(Array{Int64, 1}, pred)

y_test=y_test[:,1]
#scor = score(clf, X_test, y_test)
#auc_pr = area_under_pr(y_test,pred1)
#r = roc(y_test,pred1)

rocdf = DataFrame(hcat(y_test,pred1,prob[:,2]))
#area_under_roc(y_test,pred1)
#chart = plotperf(y_test,pred1)

#draw(SVG("myplot.svg", 4inch, 3inch), chart)
writetable("true-pred-roc.csv", rocdf)

























features1 = DataArray(df[[:Age_Yrs, :Gender, :Temp, :Pulse, :Resp, :Bpsys, :Bpdia]])
labels1 = DataArray(df[[:Blood_Culture_value]])
Xa1 = convert(Array, features1)
ya1 = convert(Array, labels1)
y1 = [x::Int for x in ya1]
yaa1 = convert(Array, y1)

data1 =(Xa1, yaa1)
X1, y1 = data1
X1 = fit_transform!(StandardScaler(), X1)
X_train1, X_test1, y_train1, y_test1 = train_test_split(X1, y1, test_size=.9)
scor1 = score(clf, X_test1, y_test1)
pred2 = ScikitLearn.predict(clf1, X_test1)
pred3 = convert(Array{Int64, 1}, pred2)
roc(y_test1,pred3)







clf1 = DecisionTreeClassifier(pruning_purity_threshold=0.9, maxdepth = 20)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=.25)
ScikitLearn.fit!(clf1, X_train, y_train)
scor = score(clf, X_test, y_test)

print(clf1)


data1 =(Xa1, yaa1)
X1, y1 = data1
X1 = fit_transform!(StandardScaler(), X1)
X_train1, X_test1, y_train1, y_test1 = train_test_split(X1, y1, test_size=.9)
scor1 = score(clf1, X_test1, y_test1)
pred2 = ScikitLearn.predict(clf1, X_test1)
pred3 = convert(Array{Int64, 1}, pred2)
roc(y_test1,pred3)


model = build_tree(yaa, Xa, 0, 5)
model = prune_tree(model, 0.9)
accuracy = nfoldCV_tree(yaa, Xa, 0.9, 300)
print_tree(model, 15)
show
println(get_classes(model))
accuracy = cross_val_score(model, Xa, yaa, cv=3)
