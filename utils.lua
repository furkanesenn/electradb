function buildConnection()
    if dbFile then
        fileClose(dbFile)
    end
    dbFile = fileOpen('databases/' .. dbname .. '.json', false)
    dbFileContent = fromJSON(fileRead(dbFile, fileGetSize(dbFile)))
end

function table.slice(tbl, first, last, step)
    local sliced = {}

    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end

    return sliced
end

function startswith(instring, inelement)
    return instring:sub(1, #inelement) == inelement 
end 

function to_array(instring)
    local str_Table = {}
    for i = 1, #instring do 
        str_Table[i] = instring:sub(i, i)
    end 
    return str_Table
end 

function replace(instring, old, new, count)
    if not tonumber(count) then count = nil end 
    return string.gsub(instring, old, new, count)
end 

function lstrip(instring, delimator)
    local arrayed = to_array(instring)
    for k, char in pairs(arrayed) do 
        if char == ' ' then 
            arrayed[k] = ''
        else
            break 
        end 
    end 
    return table.concat(arrayed)
end 



function table.len(tbl) size1 = 0 for _ in pairs(tbl) do size1 = size1 + 1 end return size1 end

function table.el(tbl, tblIndex) cnt = 0 for _, v in pairs(tbl) do cnt = cnt + 1 if cnt == tblIndex then return v end end return nil end 

function table.index(tbl, element) 
    for i,j in pairs(tbl) do 
        if j == element then return i end 
        if type(j) == 'table' then 
            for k, v in pairs(j) do 
                if v == element then return i end
            end 
        end     
    end 
    return nil
end 

function delContent()
    fileClose(dbFile)
    dbFile = fileCreate('databases/' .. dbname .. '.json')
    buildConnection()
end 



function getDatabaseSections()
    buildConnection()
    return dbFileContent['dbcontent']
end 

function getSectionBaseStructure(sectionName)
    buildConnection()
    return dbFileContent['dbcontent'][sectionName]['baseStructure']
end 

function getSectionRecords(sectionName)
    buildConnection()
    return table.slice(dbFileContent['dbcontent'][sectionName], 2, #dbFileContent['dbcontent'][sectionName])
end     

