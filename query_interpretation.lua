function handleQuery(query)
    if startswith(query, 'UPDATE') then 
        -- update 
        print('Update Query Detected')
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
        print(unpack(fetchData(roadmap[1], roadmap[2], unpack(roadmap[3]))))
        
    elseif startswith(query, 'TO SECTION') then 
        -- insert
        print('Insert Query Detected')
    else 
        print ('Unexpected Query, you have an error in your ElectraDB Query. Please check it.')
    end 
end 

handleQuery('FROM SECTION accounts, GET password, WHERE username IS ana2n')