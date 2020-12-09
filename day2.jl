# Tested in Julia 1.5.1
using DelimitedFiles
data = readdlm("./data/adventInput02.txt")
function PasswordPhilosophy(data; position = false)
    validPasswords = 0
    for (policy, letter, password) in eachrow(data)
        policy_ranges = parse.(Int, split(policy, "-"))
        policy_letter = letter[1:1]
        if position == false
            countLetter = count(x-> (x == only("$(policy_letter)")), password)
            if policy_ranges[1]<= countLetter <=policy_ranges[2]
                validPasswords += 1
            end
        elseif position == true
            positions = findall(x -> (x == only("$(policy_letter)")), password)
            isone = sum([n in positions for n in policy_ranges])
            if isone == 1
                validPasswords += 1
            end
        end
    end
    validPasswords
end
PasswordPhilosophy(data; position=false)
PasswordPhilosophy(data; position=true)
