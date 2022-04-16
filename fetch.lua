-- FROM SECTION accounts, GET username, WHERE id IS 5

function fetchData(fromSection, values, whereData, whereValue)
    -- fromSection: str, values: table, whereName: str, whereValue: str
    buildConnection()
    if not whereData then
        whereData = ''
    end
    if not whereValue then
        whereValue = ''
    end
    local sectionContent = dbFileContent['dbcontent'][fromSection]
    local baseStructure = sectionContent['baseStructure']
    local indexes = {}

    local condition = false

    if whereData ~= '' and whereValue ~= '' then
        condition = true
        local whereDataIndex = table.index(baseStructure, whereData)
        condition = { whereDataIndex, whereValue }
    end

    for _, v in pairs(values) do
        local index = table.index(baseStructure, v)
        if index then
            table.insert(indexes, index)
        end
    end

    local returnValues = {}

    for key, value in pairs(sectionContent) do

        if key ~= 'baseStructure' then
            if condition ~= false then
                if (value[condition[1]] == condition[2]) then
                    local section = {}
                    for i, j in pairs(indexes) do
                        table.insert(section, value[j])
                    end
                    table.insert(returnValues, section)
                end
            else
                local section = {}
                for i, j in pairs(indexes) do
                    table.insert(section, value[j])
                end
                table.insert(returnValues, section)
            end


        end
    end
    return returnValues;
end 

