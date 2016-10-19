using DataFrames

df = readtable("sepsis_imputed.csv")
dfr = ""
for row in eachrow(head(df))
  dfr=row
end


total = 45487
true_neg = 0
true_pos = 0
false_neg = 0
false_pos = 0

function eval_pred(int,row)
  if int == row[:Blood_Culture_value] & row[:Blood_Culture_value] == 1
    global true_pos = global true_pos + 1
  elseif int == row[:Blood_Culture_value] & row[:Blood_Culture_value] == 0
    global true_neg = global true_neg + 1
  elseif int != row[:Blood_Culture_value] & row[:Blood_Culture_value] == 0
    global false_pos = global false_pos + 1
  elseif int != row[:Blood_Culture_value] & row[:Blood_Culture_value] == 1
    global false_neg = global false_neg +1
  end
end


function dec_tree_predict(row)
  if row[:Temp] < 99.8
    eval_pred(0, row)
  elseif row[:Temp] >= 99.8
    if row[:Age_Yrs] < 57
      if row[:Pulse] > 206
        if row[:Temp] < 102
          eval_pred(1, row)
        else eval_pred(0, row)
        end
      else eval_pred(0, row)
      end
    else eval_pred(0, row)
    end
    if row[:Age_Yrs] >= 57
      if row[:Temp] >=100.6
        if row[:Pulse] >= 120
          if row[:Resp] >= 32
            eval_pred(1, row)
          else eval_pred(0, row)
          end
        else eval_pred(0, row)
        end
      else eval_pred(0, row)
      end
    else eval_pred(0, row)
    end
  else eval_pred(0, row)
  end
end

for row in eachrow(df)
  dec_tree_predict(row)
end


true_neg
true_pos
false_neg
false_pos
