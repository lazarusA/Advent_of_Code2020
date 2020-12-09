# Tested in Julia 1.5.1
using DelimitedFiles, Unicode
data = readdlm("./data/adventInput04.txt", ',', skipblanks= false)
expectedFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid"]

function passportsDict(data)
    allpassports = []
    for row in data
        push!(allpassports, split(row, ' ')...)
    end
    passports = Dict()
    passKeys = Dict{String,String}()
    c = 1
    lenpass = length(allpassports)
    for i in 1:lenpass
        keyval = allpassports[i]
        if keyval == "" || i == lenpass
            if i == lenpass
               key, val = split(keyval, ':')
                passKeys[key] = val
            end
            passports["Passport_$(c)"] = passKeys
            passKeys = Dict{String,String}()
            c += 1
        else
            key, val = split(keyval, ':')
            passKeys[key] = val
        end
    end
    passports
end
function validpassport(passport; m = "cid" )
    for k in expectedFields
        keyin = haskey(passport, k)
       if keyin == false && k == m
           return true
        elseif keyin == false
            return false
        elseif keyin == true && k == m
            return true
        end
    end
end
function validCount(passports)
    c = 0
    for (k, passport) in passports
        c += validpassport(passport)
    end
    c
end

passports = passportsDict(data)
validCount(passports)
# More rules !
eyeColors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
paramsDigits = Dict()
paramsDigits["byr"] = [1920,2002]
paramsDigits["iyr"] = [2010,2020]
paramsDigits["eyr"] = [2020,2030]

function validDigits(passport; key = "byr", min = 1920, max = 2002)
    is4digits = tryparse(Int, passport[key])
    if is4digits == nothing
        return false
    elseif min <= is4digits <= max
        return true
    else
        return false
    end
end
function validYears(passport)
    cdigtis = 0
    for (k, v)  in paramsDigits
        c = validDigits(passport; key = k, min = v[1], max = v[2])
        if c == 1
            cdigtis += 1
        else
            break
        end
    end
    cdigtis == 3 ? true : false
end
function validUnits(passport)
    unitsRange = Dict()
    unitsRange["in"] = [59,76]
    unitsRange["cm"] = [150,193]

    digit = []
    for s in passport["hgt"]
        if isdigit(s)
            push!(digit, "$(s)")
        end
    end
    isin = occursin(prod(digit), passport["hgt"])
    digit = parse(Int, prod(digit))

    units = [match.match for match in eachmatch(r"(in|cm)", passport["hgt"])]
    if isin == true && length(units) > 0
        cm_in = units[1]
        min, max = unitsRange[cm_in][1], unitsRange[cm_in][2]
        if cm_in == "in" &&  min <= digit <= max
            return true
        elseif cm_in == "cm" &&  min <= digit <= max
            return true
        else
            return false
        end
    elseif isin == false || length(units) == 0
        return false
    end
end

function validColor(passport)
    color = passport["hcl"]
    if color[1] == '#'
        return checkChars(color)
    else
        return false
    end
end
function checkChars(color; lenChars = 6, minchar = 'a', maxchar = 'f')
    vc = 0
    for c in color[2:end]
        if isdigit(c) == false && isuppercase(c) == false && minchar <= c <= maxchar
            vc += 1
        elseif isdigit(c) == true && 0 <= parse(Int,c) <= 9
            vc += 1
        else
            break
        end
    end
    vc == lenChars ? true : false
end
validEyeColor(passport; eyeColors = eyeColors) = passport["ecl"] in eyeColors
function validPid(passport; numdigit = 9)
   lendigit = 0
    for d in passport["pid"]
        lendigit += isdigit(d)
    end
    lendigit == numdigit ? true : false
end
function validCountRules(passports)
    c = 0
    for (k, p) in passports
        if validpassport(p)
            isvalid = validYears(p) + validUnits(p) + validColor(p) + validEyeColor(p) + validPid(p) == 5
            c += isvalid
        end
    end
    c
end
validCountRules(passports)
