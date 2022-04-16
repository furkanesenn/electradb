-- TO SECTION accounts, VALUES(sth, sth, sth, sth), WHERE username IS 'Sthhere'


function insertData(toSection, values) -- values: table, toSection: str
    buildConnection()

    local sectionContent = dbFileContent['dbcontent'][toSection]
    local sectionBaseStructure = sectionContent['baseStructure']
    local id = math.random(1, 99999)
    table.insert(sectionContent, id, {})

    for key, baseStructure in pairs(sectionBaseStructure) do 
        if values[key] then
            table.insert(sectionContent[id], key, values[key])
        else 
            table.insert(sectionContent[id], key, baseStructure[3])
        end 
    end 


    local dataJSON = toJSON(dbFileContent, true, 'tabs')
    delContent()
    fileWrite(dbFile, dataJSON)
    fileFlush(dbFile)
    buildConnection()

    return true
end 


-- UPDATE accounts, SET id TO 5, WHERE username is 'astreal'

function updateData(inSection, whichData, toValue, whereData, whereValue)

    buildConnection()
    local sectionContent = dbFileContent['dbcontent'][inSection]
    local baseStructure = sectionContent['baseStructure']

    local dataIndex = table.index(baseStructure, whichData)
    local condition = false 

    if whereData ~= '' and whereValue ~= '' then 
        condition = true
        local whereDataIndex = table.index(baseStructure, whereData)
        condition = {whereDataIndex, whereValue}
    end 

    for key, value in pairs(sectionContent) do
        if key ~= 'baseStructure' then
            if condition ~= false then
                if (value[condition[1]] == condition[2])  then 
                    value[dataIndex] = toValue 
                end 
            else 
                value[dataIndex] = toValue 
            end 

            sectionContent[key] = value 
        end 
    end 
    dbFileContent['dbcontent'][inSection] = sectionContent


    local dataJSON = toJSON(dbFileContent, true, 'tabs')
    delContent()
    fileWrite(dbFile, dataJSON)
    fileFlush(dbFile)
    buildConnection()

    return true
end 

