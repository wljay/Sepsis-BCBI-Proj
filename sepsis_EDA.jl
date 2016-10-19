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
  println("$(col[1]) na: $ctt %")
end

for col in eachcol(df)
  count_NA(col)
end
