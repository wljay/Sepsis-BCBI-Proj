using DataFrames
using DataFramesMeta

df = readtable("Sepsis_May_April.csv")


for i = 1:100
  for row = 1:size(df, 1)
    if row+1 != size(df,1)+1
      if df[row, :Encounter_ID] == df[row+1, :Encounter_ID]
        for col = 12:28
          if isna(df[row, col]) & !isna(df[row+1, col])
            df[row, col] =  df[row+1, col]
          end
        end
      end
    end
  end
end

df[3,12]

writetable("Sepsis_filled.csv", df)
