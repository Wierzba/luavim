--			AUXILIARY			--

--splits string on pattern occurances into output as table
function split(input, pattern)
	local output = {}
	local searchPattern = "(.-)"..pattern
	local lastEnd = 1
	local s, e, cap = input:find(searchPattern, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(output,cap)
		end
		lastEnd = e+1
		s, e, cap = input:find(searchPattern, lastEnd)
	end
	if lastEnd <= #input then
		cap = input:sub(lastEnd)
		table.insert(output, cap)
	end
	return output
end

--reads file's content, returns string
function fileRead(filepath)
	file = io.open(filepath,"r")
	if file then--successfully loaded
		fileContent = file:read("*all")
		file:close()
		output = split(fileContent,'\n')
	else        --loading failed
		io.write('File "'..filepath..'" does not exist.\n')
	end
	return output
end

--saves inputs's content to file at filepath
--input is a table
function fileSave(filepath,input)
	file = io.open(filepath,"w")
	for lineNumer=1,# input do
		file:write(input[lineNumer]..'\n')
	end
end

--			CONTENT			--

--writes string in given formatted fashion
function contentWrite(input, flagLineEnumeration)
	local linesTotal = #input
	local leadingZeroMax = math.ceil(math.log10(linesTotal+1))
	for lineNumer=1,# input do
		if (flagLineEnumeration == 1) then
			io.write(string.format("%0"..leadingZeroMax.."d: ",lineNumer)..input[lineNumer]..'\n')
		else
			io.write(input[lineNumer]..'\n')
		end
	end
end

--			CHARACTERS IN LINES			--

--replaces character at position in input
--if position invalid, return unchanged
function charReplace(input,position,character)
	if(position > string.len(input) or position < 1) then return input; end
	return table.concat{input:sub(1,position-1),character,input:sub(position+1)}
end
--adds character before position in line(input)
--if position too big/small, push back/front
function charAddPre(input,position,character)
	if(position == 0) then return charPushFront(input,character); end
	return table.concat{input:sub(1,position-1),character,input:sub(position)}
end
--adds character after position in line(input)
--if position too big/small, push back/front
function charAddPost(input,position,character)
	if(position == 0) then return charPushFront(input,character); end
	return table.concat{input:sub(1,position),character,input:sub(position+1)}
end
--removes character at position in line(input)
--if position invalid, return unchanged
function charRemove(input,position)
	if(position == 0) then return input; end
	return table.concat{input:sub(1,position-1),input:sub(position+1)}
end
--adds character at the end of line(input)
function charPushBack(input,character)
	return table.concat{input,character}
end
--adds character at the beginning of line(input)
function charPushFront(input,character)
	return table.concat{character,input}
end
--removes first character of line(input)
function charPopFront(input)
	return table.concat{input:sub(2,position)}
end
--removes last character of line(input)
function charPopBack(input)
	return table.concat{input:sub(1,position-1)}
end

--			LINES IN CONTENT			--

--replaces a line at position in content with input
function lineReplace(content, input, position)
	input = input or ""
	if(position > 0 and position <= #content) then
		table.remove(content,position)
		table.insert(content,position,input)
	end
end
--adds input before position in content
function lineAddLinePre(content, input, position)
	input = input or ""
	table.insert(content,position,input)
end
--adds input after position in content
function lineAddLinePost(content, input, position)
	input = input or ""
	table.insert(content,position+1,input)
end
--inserts a line(input) at the end of content
--input is empty line by default
function linePushBack(content, input)
	input = input or ""
	table.insert(content,input)
end
--inserts a line (input) at the beginning of content
--input is empty line by default
function linePushFront(content, input)
	input = input or ""
	table.insert(content,1,input)
end
--removes first line in content
function linePopFront(content)
	table.remove(content,1)
end
--removes last line in content
function linePopBack(content, input)
	table.remove(content,#content)
end

--			Examplatory Usage			--

--should not break at reading empty files - maybe even create new ones
fileContent = fileRead("empty.txt")
--read file to buffer as table
fileContent = fileRead("example.txt")
--write buffer
contentWrite(fileContent)

--append new lines
lineAddLinePre(fileContent,"NewLine!",2)
lineAddLinePost(fileContent,"abcdefgh",2)
--change/add/remove characters within existing lines
fileContent[3] = charReplace(fileContent[3],1,'A')
fileContent[3] = charAddPost(fileContent[3],3,'?')
fileContent[3] = charAddPre(fileContent[3],3,'?')
fileContent[1] = charRemove(fileContent[1],0)
fileContent[1] = charRemove(fileContent[1],67)
fileContent[1] = charAddPre(fileContent[1],0,'?')
--mess with lines an itty-bitty more
linePushBack(fileContent)
linePushBack(fileContent)
linePushBack(fileContent,"Lastest Line")
linePushFront(fileContent,"Firstest Line")
linePopBack(fileContent)
linePopFront(fileContent)
lineAddLinePost(fileContent,"post",12)
lineReplace(fileContent,"replace",12)
lineAddLinePre(fileContent,"pre",12)
lineReplace(fileContent,"replace",0)
lineReplace(fileContent,"replace",17)

contentWrite(fileContent,1)
--save buffer to file
fileSave("output.txt",fileContent)
