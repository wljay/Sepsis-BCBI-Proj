using DataFrames

df = readtable("Sepsis_filled_merged_nacounted_coded1.csv")
arr = df[:Blood_Culture_value]
res = DataArray(Any, length(df[:Gender]))
for i in 1:length(df[:Gender])
  if isna(arr[i]) || arr[i] == "No growth after 5 days." || arr[i] == "No growth after 10 days."
      res[i] = 0
  else
     res[i] = 1
  end
end

res
df = hcat(df, res)

writetable("Sepsis_final.csv", df)
