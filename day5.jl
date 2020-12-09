# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput05.txt")
function findRowColumn(string; first = 0, last = 127, upStr = 'B', lowStr = 'F')
    planeRows = first:last
    cStr = string[1]
    for s in string
        if s == upStr
            first = planeRows.start + Int(length(planeRows)/2)
            last = planeRows.stop
            planeRows = first:last
        elseif s == lowStr
            first = planeRows.start
            last = first + Int(length(planeRows)/2-1)
            planeRows = first:last
        end
        cStr = s
    end
    cStr == lowStr ? planeRows.start : planeRows.stop
end
function maxIdBoardingPass(data)
    idBoardingPass = 0
    for s in data
        posRow = findRowColumn(s)
        posCol = findRowColumn(s; first=0, last = 7, upStr = 'R', lowStr = 'L')
        idBoadPass = posRow *8 + posCol
        idBoardingPass =  idBoadPass > idBoardingPass ? idBoadPass : idBoardingPass
    end
    idBoardingPass
end
function IdsBoardingPass(data)
    idsBPass = []
    for s in data
        posRow = findRowColumn(s)
        posCol = findRowColumn(s; first=0, last = 7, upStr = 'R', lowStr = 'L')
        idBoadPass = posRow *8 + posCol
        push!(idsBPass, idBoadPass)
    end
    idsBPass
end
function findSeat(IdsBP)
    for s_id in 1:maximum(IdsBP)
        ismyseat = s_id ∉ IdsBP
        isplus1  = s_id + 1 ∈ IdsBP
        isminus1 = s_id - 1 ∈ IdsBP
        if ismyseat && isplus1 && isminus1
            return s_id
        end
    end
end
maximum(IdsBoardingPass(data))
findSeat(IdsBoardingPass(data))
