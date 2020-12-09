# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput08.txt")
function accLoop(data;acc= 0, indx = 1)
    usedIndx = [indx]
    outIndx = false
    for i in 1:size(data)[1]
        op, arg = data[indx,:]
        if op == "acc"
            acc += arg
            indx += 1
            outIndx = indx == size(data)[1]+1
            if outIndx
                break
            end
            indx ∉ usedIndx ? push!(usedIndx, indx) : break
        elseif op == "jmp"
            indx += arg
            outIndx = indx == size(data)[1]+1
            if outIndx
                break
            end
            indx ∉ usedIndx ? push!(usedIndx, indx) : break
        elseif op == "nop"
            indx += 1
            outIndx = indx == size(data)[1]+1
            if outIndx
                break
            end
            indx ∉ usedIndx ? push!(usedIndx, indx) : break
        end
    end
    acc, outIndx
end
function fixingBug(data; acc=0, outIndx = false)
    for (indx,(op, arg)) in enumerate(eachrow(data))
        if op == "jmp"
            data_tmp = copy(data)
            data_tmp[indx,1] = "nop"
            acc, outIndx = accLoop(data_tmp)
            if outIndx
                println(indx)
                break
            end
        elseif op == "nop"
            data_tmp = copy(data)
            data_tmp[indx,1] = "jmp"
            acc, outIndx = accLoop(data_tmp)
            if outIndx
                println(indx)
                break
            end
        end
    end
    acc
end
accLoop(data)
fixingBug(data)
