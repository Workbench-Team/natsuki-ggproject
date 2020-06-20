function split(str, size)
        local s = {}
        for i=1, #str, size do
                s[#s+1] = str:sub(i, i+size - 1)
        end
        return s
end
