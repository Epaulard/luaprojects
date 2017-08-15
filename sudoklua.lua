-- Sudoku solver implementation
-- Initial version using only Backtracking and recursion
-- Initial version is a fork from  Algorithm-Implementations / Sudoku / Lua / Yonaba / sudoku.lua (https://github.com/Yonaba)



-- Display the sudoku.
-- Building a string for each line
local function display(sudoku)
print (('-'):rep(S+10))
  for row = 1, S do
    local line = "| "
    for column = 1, S do
      line=line..(string.format("%s", sudoku[row][column]))
      if ((column % 3)== 0) then line=line.." | " end
    end
    print(string.format("%s", line))
    if ((row % 3)== 0) then print (('-'):rep(S+10)) end
  end
end

-- Checks if num exists on a row
local function rowHasNotNum(sudoku, row, num)
  for column = 1,S do
    if sudoku[row][column] == num then
      return false
    end
  end
  return true
end

-- Checks if num exists on a column
local function columnHasNotNum(sudoku, column, num)
  for row = 1,S do
    if sudoku[row][column] == num then return false end
  end
  return true
end

-- Given a (row, column) location on the sudoku grid
-- identifies the corresponding 3x3 box and checks if
-- num exists in this box
local function boxHasNotNum(sudoku, row, column, num)
  row = math.floor((row - 1) / 3) * 3 + 1
  column = math.floor((column - 1) / 3) * 3 + 1
  for rwOffset = 0, 2 do
    for clOffset = 0, 2 do
      if sudoku[row + rwOffset][column + clOffset] == num then
        return false
      end
    end
  end
  return true
end

-- Checks if num can be assigned to sudoku[row][column]
-- without breaking sudoku rules.
local function isLegit(sudoku, row, column, num)
  return rowHasNotNum(sudoku, row, num)
    and columnHasNotNum(sudoku, column, num)
    and boxHasNotNum(sudoku, row, column, num)
end


-- Checks if the actual problem is solved.
-- If not, returns false, plus the location on the
-- first unassigned cell found.
local function isSolved(sudoku)
  for row = 1, S do
    for column = 1, S do
      if sudoku[row][column] == 0 then
        return false, row, column
      end
    end
  end
  return true
end

-- Sudoku solving via backtracking and recursion
-- sudoku  : a 2-dimensional grid of numbers (0-S)
--           0 matches unknown values to be found.
-- returns : true, if a solution was found,
--           false otherwise.
local function solve(sudoku)
  local solved, row, column = isSolved(sudoku)
  if solved then return true end
  for num = 1, S do
    if isLegit(sudoku, row, column, num) then
      sudoku[row][column] = num
      if solve(sudoku) then return true end
      sudoku[row][column] = 0
    end
  end
  return false
end




local total, pass = 0, 0

local function dec(str, len)
  return #str < len
     and str .. (('.'):rep(len-#str))
      or str:sub(1,len)
end

local function run(message, f)
  total = total + 1
  local ok, err = pcall(f)
  if ok then pass = pass + 1 end
  local status = ok and 'PASSED' or 'FAILED'
  print(('%02d. %68s: %s'):format(total, dec(message,68), status))
end

-- Checks if t1 and t2 arrays are the same
local function same(t1, t2)
  if #t1 ~= #t2 then return false end
  for r, row in ipairs(t1) do
    for v, value in ipairs(row) do
      if t2[r][v] ~= value then return false end
    end
  end
  return true
end

run('An easy problem', function()
  local problem = {
    {3, 0, 6, 5, 0, 8, 4, 0, 0},
    {5, 2, 0, 0, 0, 0, 0, 0, 0},
    {0, 8, 7, 0, 0, 0, 0, 3, 1},
    {0, 0, 3, 0, 1, 0, 0, 8, 0},
    {9, 0, 0, 8, 6, 3, 0, 0, 5},
    {0, 5, 0, 0, 9, 0, 6, 0, 0},
    {1, 3, 0, 0, 0, 0, 2, 5, 6},
    {0, 0, 0, 0, 0, 0, 0, 7, 4},
    {0, 0, 0, 0, 8, 6, 3, 1, 9},
  }

  local solution = {
    {3, 1, 6, 5, 7, 8, 4, 9, 2},
    {5, 2, 9, 1, 3, 4, 7, 6, 8},
    {4, 8, 7, 6, 2, 9, 5, 3, 1},
    {2, 6, 3, 4, 1, 5, 9, 8, 7},
    {9, 7, 4, 8, 6, 3, 1, 2, 5},
    {8, 5, 1, 7, 9, 2, 6, 4, 3},
    {1, 3, 8, 9, 4, 7, 2, 5, 6},
    {6, 9, 2, 3, 5, 1, 8, 7, 4},
    {7, 4, 5, 2, 8, 6, 3, 1, 9},
  }
  S=9
  solve(problem)
  display(problem)
  assert(same(problem, solution))
  print(os.clock ())
end)

run('A harder problem', function()
  local problem = {
    {9, 0, 0, 1, 0, 0, 0, 0, 5},
    {0, 0, 5, 0, 9, 0, 2, 0, 1},
    {8, 0, 0, 0, 4, 0, 0, 0, 0},
    {0, 0, 0, 0, 8, 0, 0, 0, 0},
    {0, 0, 0, 7, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 2, 6, 0, 0, 9},
    {2, 0, 0, 3, 0, 0, 0, 0, 6},
    {0, 0, 0, 2, 0, 0, 9, 0, 0},
    {0, 0, 1, 9, 0, 4, 5, 7, 0},
  }

  local solution = {
    {9, 3, 4, 1, 7, 2, 6, 8, 5},
    {7, 6, 5, 8, 9, 3, 2, 4, 1},
    {8, 1, 2, 6, 4, 5, 3, 9, 7},
    {4, 2, 9, 5, 8, 1, 7, 6, 3},
    {6, 5, 8, 7, 3, 9, 1, 2, 4},
    {1, 7, 3, 4, 2, 6, 8, 5, 9},
    {2, 9, 7, 3, 5, 8, 4, 1, 6},
    {5, 4, 6, 2, 1, 7, 9, 3, 8},
    {3, 8, 1, 9, 6, 4, 5, 7, 2},
  }
  S=9
  solve(problem)
  display(problem)
  assert(same(problem, solution))
  print(os.clock ())
end)

print(('-'):rep(80))
print(('Total : %02d: Pass: %02d - Failed : %02d - Success: %.2f %%')
  :format(total, pass, total-pass, (pass*100/total)))

