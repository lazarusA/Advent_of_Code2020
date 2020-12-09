# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput07.txt", '.')[:,1]
function bagsInDict(bagsList)
    bagsIn = Dict{String,String}()
    for b in bagsList
        if length(b) > 0
            nbags = b |> rstrip |> lstrip
            q = split(nbags, ' ')[1]
            bagsIn[nbags[length(q)+2:end]] = q
        end
    end
    bagsIn
end
function bagsOutDict(data)
    bagsOut = Dict{String,Dict}()
    for d in data
        pbag, mbag = split(d, r" contain ")
        bagsList = split(mbag, r"(bags|bag|,)")
        keyOut = split(pbag, r"(bags|bag|,)")[1] |> rstrip |> lstrip
        bagsOut[keyOut] = bagsInDict(bagsList)
    end
    bagsOut
end
# here all color bags with all sub bags...
bagColors = bagsOutDict(data)
# now what?...
