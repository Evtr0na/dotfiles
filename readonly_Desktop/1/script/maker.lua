local file_path = "C:/Users/SDD/Desktop/1/2/hello_world.md"

local file, err = io.open(file_path, "w")

if not file then
	print("fail to make  file:" .. err)
	return
end

file:write("hello\n")
file:write("world")

file:close()

print("Mdrkdown made succeful" .. file_path)
