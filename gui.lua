local BeautifulLibrary = loadstring(game:HttpGet("ССЫЛКА_НА_RAW_ФАЙЛ"))()

local Window = BeautifulLibrary:CreateWindow({
    Name = "✨ Super HUB",
    ThemeColor = Color3.fromRGB(255, 70, 130),
    AccentColor = Color3.fromRGB(70, 130, 255),
    BackgroundBlur = true -- опционально, размытие фона
})

local MainTab = Window:CreateTab("Главная", "6022668685") -- ID иконки (например, меч)
local PlayerSection = MainTab:CreateSection("Игрок")

PlayerSection:CreateButton({
    Name = "💰 Дать денег",
    Callback = function() print("Деньги добавлены!") end
})

local toggle = PlayerSection:CreateToggle({
    Name = "🛡️ Бессмертие",
    Default = false,
    Callback = function(state) print("God Mode:", state) end
})

local slider = PlayerSection:CreateSlider({
    Name = "🏃 Скорость ходьбы",
    Min = 16, Max = 300, Default = 16,
    Suffix = " studs",
    Callback = function(v) print("Speed:", v) end
})

local dropdown = PlayerSection:CreateDropdown({
    Name = "📍 Телепорт",
    Options = {"Спавн", "Магазин", "Арена"},
    Callback = function(opt) print("Teleport to", opt) end
})

Window:Notify({
    Title = "✅ Успешно!",
    Content = "Ваше меню загружено.",
    Duration = 5
})
