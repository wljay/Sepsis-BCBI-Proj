using DataFrames

df = readtable("C:/Users/Jason/Documents/BCBI/Atom/Sepsis_filled_merged_nacounted1.csv")

function make_code_dict(col)
  code_dict = Dict()
  ct = 0
  for i in col
    if !haskey(code_dict, i)
      code_dict[i] = ct
      ct = ct+1
    end
  end
  return code_dict
end

function count_NA(col)
  ct  = 0
  for i in col[2]
    if isna(i)
      ct = ct+1
    end
  end
  ctt =ct
  return ctt
end

function code_array(arr, dict)
    n = length(arr)
    res = DataArray(Any, n)
    for i = 1:n
        if !isna(arr[i])
            res[i] = dict[arr[i]]
        end
    end
    return res
end


gender_dict = make_code_dict(df[:Gender])
gender_coded = code_array(df[:Gender], gender_dict)
df = hcat(df, gender_coded)
encounter_dict = make_code_dict((df[:Encounter_dept]))
encounter_coded = code_array(df[:Encounter_dept], encounter_dict)
df = hcat(df, encounter_coded)

for key in sort(collect(keys(encounter_dict)))
           println("$key => $(encounter_dict[key])")
       end

genderleg  = println(gender_dict)
writetable("Sepsis_filled_merged_nacounted_coded.csv", df)
write("Gender_legend.txt", genderleg)
