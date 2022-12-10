Funiq ← { 𝕨+⊐⟜𝕨∾(⥊+˝)¨∊¨<˘𝕨↕𝕩 }

# 𝕨+  # add 𝕨 
# ⊐⟜𝕨 # first element = 𝕨
# ∾   # flatten into list
# ⥊¨  # map 'ravel' = reshape into list
# +˝¨ # add up mask together
# ∊¨  # map unique mask over each window
# <˘  # table to list
# 𝕨↕𝕩 # window 𝕨 over 𝕩
⊐⟜4∾⥊∘+˝∘∊¨<˘4 ↕•FChars "inputs/day06_input.txt"

•Show 4 Funiq •FChars "inputs/day06_input.txt"
•Show 14 Funiq •FChars "inputs/day06_input.txt"
