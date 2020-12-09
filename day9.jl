# Tested in Julia 1.5.1
using DelimitedFiles, Combinatorics
data = readdlm("./data/adventInput09.txt", Int64)
function ValidOr(preamble, nextNum; d = 2)
    pairs = permutations(preamble, d)
    c = 0
    for p in pairs
        c += 1
        if p[1] != p[2] && sum(p) == nextNum
            return true
            break
        elseif c == length(pairs)
            return false
        end
    end
end
function findNotValid(data; idx = 1, lastStep = 25)
    for i in 1:length(data)
        preamble = data[idx:lastStep]
        nextNum = data[lastStep + 1]
        if ValidOr(preamble, nextNum; d = 2) == false
            return nextNum
            break
        end
        lastStep += 1
        idx += 1
    end
end
function encryptionWeakness(data)
    notvalid = findNotValid(data)
    for i in 1:length(data)
        sumInvalid = data[i]
        for j in i+1:length(data)
            sumInvalid += data[j]
            if sumInvalid == notvalid
                return minimum(data[i:j]) + maximum(data[i:j])
                break
            end
        end
    end
end
encryptionWeakness(data)
