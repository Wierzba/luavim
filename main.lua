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
function replaceChar(input,position,character)
	return table.concat{input:sub(1,position-1),character,input:sub(position+1)}
end
function postAddChar(input,position,character)
	return table.concat{input:sub(1,position),character,input:sub(position+1)}
end
function preAddChar(input,position,character)
	return table.concat{input:sub(1,position-1),character,input:sub(position)}
end

--reads file's content, returns string
function readFile(filepath)
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
function saveFile(filepath,input)
	file = io.open(filepath,"w")
	for lineNumer=1,# input do
		file:write(input[lineNumer]..'\n')
	end
end

--writes string in given formatted fashion
function writeContent(input, flagLineEnumeration)
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

--test case usage
--should not break at reading empty files - maybe even create new ones
fileContent = readFile("empty.txt")
--read file to buffer as table
fileContent = readFile("example.txt")
--write buffer
writeContent(fileContent)
io.write('\n')
--append new lines
table.insert(fileContent,2,"NewLine!")
table.insert(fileContent,3,"abcdefgh")
io.write(fileContent[3]..'\n')
--change/add characters within line
fileContent[3] = replaceChar(fileContent[3],1,'A')
fileContent[3] = postAddChar(fileContent[3],3,'?')
fileContent[3] = preAddChar(fileContent[3],3,'?')
io.write(fileContent[3]..'\n')
io.write('\n')
writeContent(fileContent,1)
--save buffer to file
saveFile("output.txt",fileContent)
