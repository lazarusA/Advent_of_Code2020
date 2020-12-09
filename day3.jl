# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput03.txt")
function TobogganTrajectory(data; current_pos = 1, right = 3, down = 1)
    c = 0
    lenrow = length(data[1])
    for row in data[1:down:end]
        if current_pos > lenrow
            row = row ^(Int(ceil(current_pos/lenrow)))
            🌲 = row[current_pos]
            if 🌲 == '#'
                c += 1
            end
        else
            🌲 = row[current_pos]
            if 🌲 == '#'
                c += 1
            end
        end
        current_pos += right
    end
    c
end
TobogganTrajectory(data)

movesRight = [1,3,5,7,1]
movesDown = [1,1,1,1,2]
narboles = [TobogganTrajectory(data; right = movesRight[n], down = movesDown[n])
        for n in 1:length(movesRight)]
prod(narboles)
