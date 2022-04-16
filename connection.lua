dbFile = nil 
dbFileContent = nil 
dbname = 'electraproject'
dbdesc = 'A wild database'

function createDatabase(applyRichStructure) 
    if not dbname then 
        dbname = 'electra' .. tostring(math.random(10000, 99999))
    end 
    if not dbdesc then 
        dbdesc = 'A wild database!'
    end 
    if not applyRichStructure then 
        applyRichStructure = false
    end 
    local expectedPath = 'databases/' .. dbname .. '.json'
    if fileExists(expectedPath) then 
        return false  
    end 
    fileCreate(expectedPath)
    dbFile = fileOpen(expectedPath, false)

    local theStructure = {
        ['dbname'] = dbname, 
        ['dbdesc'] = dbdesc,
        ['dbcontent'] = {}
    }

    if applyRichStructure then 
        theStructure['dbcontent'] = {
            ['accounts'] = {
                ['baseStructure'] = {
                    {'id', 'int', 1}, {'username', 'str', ''}, {'password', 'str', ''}, {'email', 'str', ''}
                }
            },
        }
    end 

    local theStructure = toJSON(theStructure, true, 'tabs')
    fileWrite(dbFile, theStructure)
    fileFlush()
    dbFileContent = fromJSON(fileRead(dbFile, fileGetSize(dbFile)))
    return true 
end 
createDatabase(true)

addEventHandler('onResourceStart', resourceRoot, function()
    dbFile = fileOpen('databases/' .. dbname .. '.json', false)
    dbFileContent = fromJSON(fileRead(dbFile, fileGetSize(dbFile)))
end)

