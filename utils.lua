function table.tostring(obj)
    if type(obj) == 'table' then
        local s = '{ '
          for k,v in pairs(obj) do
             if type(k) ~= 'number' then k = '"'..k..'"' end
             s = s .. '['..k..'] = ' .. table.tostring(v) .. ','
          end
        return s .. '} '
    else
        return tostring(obj)
    end
end

function table.print(_table)
    print(table.tostring(_table))
end

function table.shallow_copy(_table, range)
  if range == nil then
    range = {1, #_table}
  end
  local _index = 1
  local _new_table = {}
  for selected_index = range[1], range[2] do
    print("copy index %d, value: %s", selected_index, _table[selected_index])
    _new_table[_index] = _table[selected_index]
    _index = _index + 1
  end
  return _new_table
end

function table.has_value (tab, val, eval)
    if eval == nil then
        eval = function (table_item, target_value)
            return table_item == target_value
        end
    end
    for _, value in ipairs(tab) do
        if eval(value, val) then
            return true
        end
    end

    return false
end

local function class(className, super)
    -- 构建类
    local clazz = { __cname = className, super = super }
    if super then
        -- 设置类的元表，此类中没有的，可以查找父类是否含有
        setmetatable(clazz, { __index = super })
    end
    -- new 方法创建类对象
    clazz.new = function(...)
        -- 构造一个对象
        local instance = {}
        -- 设置对象的元表为当前类，这样，对象就可以调用当前类生命的方法了
        setmetatable(instance, { __index = clazz })
        if clazz.__init__ then
            clazz.__init__(instance, ...)
        end
        return instance
    end
    return clazz
end

collections = {}

collections.Counter = class('collections.Counter')

function collections.Counter:update(value)
    self.counter_table[value] = (self.counter_table[value] or 0) + 1
end

function collections.Counter:__init__(counter_table, _table)
    self.counter_table = counter_table or {}
    if _table then
        for _, value in ipairs(_table) do
            self:update(value)
        end
    end
end

function collections.Counter:tostring()
    return table.tostring(self.counter_table)
end

function collections.Counter:get_table()
    return self.counter_table
end