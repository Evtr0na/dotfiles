-- local path_ = "C:/Users/SDD/Desktop/1/2/123.md"
local path_ = "C:/Users/SDD/Desktop/1/2/1111.md"
local a_ = 3
local b_ = 19
local c_ = 0
local file, _ = io.open(path_, "w")

if not file then
	print("123")
	return
end

c_ = #tostring(a_ * b_)

for i = 1, a_ do
	for a = 1, b_ do
		local value = i * a
		file:write("|")
		file:write(value)
		for _ = 1, c_ - #tostring(value) do
			file:write(" ")
		end
	end
	file:write("\n")
end

file.close(file)

print("Mdrkdown made succeful" .. path_)
