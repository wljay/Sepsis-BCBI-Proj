using DataFrames

df = readtable("Sepsis_filled_merged.csv")

function count_NA(col)
  ct  = 0
  for i in col[2]
    if isna(i)
      ct = ct+1
    end
  end
  ctt =round( ct /size(df, 1) *100)
  return ctt
end

for col in eachcol(df)
  if count_NA(col) > 60
    delete!(df, col[1])
  end
end

size(df)

for col in eachcol(df)
  println("$(col[1]) : $(count_NA(col))%")
end

writetable("Sepsis_filled_merged_nacounted.csv", df)
