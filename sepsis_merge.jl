using DataFrames

df = readtable("Sepsis_filled.csv")
df_merge = df[1, 1:22]
id_dict = Dict()
id_dict[df[1,1]] = 1

for row = 1:size(df, 1)-1
  id = df[row, :Encounter_ID]
  if !haskey(id_dict, id)
    id_dict[id] = 1
    append!(df_merge, df[row, 1:22])
  else
    id_dict[id] += 1
  end
end

df_merge
head(df_merge)
writetable("Sepsis_filled_merged.csv", df_merge)
