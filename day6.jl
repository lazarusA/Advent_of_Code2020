# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput06.txt", ',', skipblanks= false)
function CustomsYes(data)
    groups = Dict()
    yesAns = []
    c = 1
    lenpass = length(data)
    for i in 1:lenpass
        yans = data[i]
        if yans == "" || i == lenpass
            if i == lenpass
               push!(yesAns, collect(yans))
            end
            groups["group_$(c)"] = yesAns
            yesAns = []
            c += 1
        else
            push!(yesAns, collect(yans))
        end
    end
    groups
end
function YesCount(groups; setOp = union)
    yes_c = 0
    for (k,v) in groups
        yes_c += length(setOp(Set.(v)...))
    end
    yes_c
end
YesCount(CustomsYes(data); setOp = union)
YesCount(CustomsYes(data); setOp = intersect)
