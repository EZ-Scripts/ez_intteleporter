Config = {}

Config.teleporter = {
    ["int3"] = { -- Interior name (e.g. int3 from spooni)
        location = {x=-1262.95, y=-981.42, z=61.42}, -- Interior location
        enter = vector4(-1199.64, -3162.44, 83.93, 207.46),
        unique = 10000001, -- unique identifier for the teleporter
        prop = "p_door10x", -- prop to create at the enter location
        dynamic = true, -- if true, the map will be removed when the player exits. More performance friendly.
    },
    ["int4"] = {
        location = {x=-1228.63, y=-967.27, z=69.36},
        enter = vector4(-1207.06, -3161.28, 83.73, 181.23),
        unique = 10000002,
        prop = "p_door10x",
        dynamic = true
    },
    ["int5"] = {
        location = {x=-1248.64, y=-1020.23, z=70.09},
        enter = vector4(-1191.47, -3160.31, 84.42, 199.21),
        unique = 10000003,
        prop = "p_door10x",
        dynamic = true
    },
}