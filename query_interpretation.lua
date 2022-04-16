function handleQuery(query)
    if startswith(query, 'UPDATE') then 
        -- update 
        sections = split(query, ',')
        local roadmap = {'UPDATE', 'SET', 'WHERE'}
        for idx ,section in pairs(sections) do
            sections[idx] = lstrip(section, ' ')
            if startswith(sections[idx], roadmap[idx]) then
                sections[idx] = lstrip(replace(sections[idx], roadmap[idx], ''), ' ')
                if roadmap[idx] == 'SET' then
                    sections[idx] = split(sections[idx], ' TO ')
                elseif roadmap[idx] == 'WHERE' then
                    local whereData, whereValue = unpack(split(lstrip(replace(sections[idx], 'is', ''), ' '), ' '))
                    sections[idx] = {whereData, whereValue}
                end

            end
        end

        return updateData(sections[1], sections[2][1], sections[2][2], sections[3][1], sections[3][2])
    elseif startswith(query, 'FROM SECTION') then 
        -- fetch
        sections = split(query, ',')
        local roadmap = {'FROM SECTION', 'GET', 'WHERE'}
        for idx, section in pairs(sections) do 
            sections[idx] = lstrip(section, ' ')
            if startswith(sections[idx], roadmap[idx]) then 
                sections[idx] = lstrip(replace(sections[idx], roadmap[idx], ''), ' ')
                if roadmap[idx] == 'GET' then 
                    if #(split(sections[idx], ';')) > 1 then
                        local gottenValues = split(sections[idx], ';')
                        for gottenKey, gottenValue in pairs(gottenValues) do 
                            gottenValues[gottenKey] = lstrip(gottenValue, ' ')
                        end
                        roadmap[idx] = gottenValues

                        gottenValues = nil 
                    else 
                        roadmap[idx] = {replace(sections[idx], ' ', '')}
                    end 
                elseif roadmap[idx] == 'WHERE' then 
                    local whereData, whereValue = unpack(split(lstrip(replace(sections[idx], 'IS', ''), ' '), ' '))
                    roadmap[idx] = {whereData, whereValue}
                else
                    roadmap[idx] = sections[idx]
                end
                
            else
                return print ('Unexpected Query, you have an error in your ElectraDB Query. Please check it.')
            end 

        end
        return fetchData(roadmap[1], roadmap[2], unpack(roadmap[3]))
        
    elseif startswith(query, 'TO SECTION') then 
        -- insert
        sections = split(query, ',')
        local roadmap = {'TO SECTION', 'VALUES'}
        for idx, section in pairs(sections) do

            sections[idx] = lstrip(section, roadmap[idx])
            if startswith(sections[idx], roadmap[idx]) then
                sections[idx] = lstrip(replace(sections[idx], roadmap[idx], ''), ' ')
                if roadmap[idx] == 'VALUES' then
                    sections[idx] = sections[idx]:sub(2, #sections[idx] - 1)
                    local values = {}
                    for _, value in pairs(split(sections[idx], ';')) do
                        value = replace(value, ' ', '');
                        table.insert(values, value)
                    end
                    sections[idx] = values
                    values = nil;
                end
            end
        end

        return insertData(sections[1], sections[2])
    else 
        print ('Unexpected Query, you have an error in your ElectraDB Query. Please check it.')
    end 
end

