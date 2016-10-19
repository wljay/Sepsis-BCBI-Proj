using DataFrames
using DataFramesMeta

df = readtable("Sepsis_May_April.csv")

for row in size(df, 1)
  if row+1 != size(df,1)+1
    if df[row, :Encounter_ID] == df[row+1, :Encounter_ID]
      for col = 12:43
        if df[row, col] == NA & df[row+1, col] != NA
          df[row, col] =  df[row+1, col]
        end
      end
    end
  end
end

writetable("Sepsis_filled.csv", df)
