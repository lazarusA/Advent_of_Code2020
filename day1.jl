# Tested in Julia 1.5.1
using DelimitedFiles, Combinatorics
data = readdlm("./data/adventInput01.txt", Int)
function ReportRepairPerm(data; nums = 2, sumto = 2020)
    for p in permutations(data, nums)
        if sum(p) == sumto
            print(p, " Sum: $(sum(p)),  Product : $(prod(p))")
            break
        end
    end
end
ReportRepairPerm(data)
ReportRepairPerm(data, nums = 3)
