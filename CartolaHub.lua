local cartolalib = loadstring(game:HttpGet("https://raw.githubusercontent.com/wx-sources/CartolaLibrary/refs/heads/main/Redzhubui%20(1).txt"))()

local Window = cartolalib:MakeWindow({
    Title = "Cartola Hub       ",
    SubTitle = "by EstherDeveloper and Davi999",
    SaveFolder = "CartolaLibrary"
})

-- Abas
local TabMain = Window:MakeTab({"Main", "home"})
local TabAudio = Window:MakeTab({"Audio", "home"})
local TabExperimental = Window:MakeTab({"OP / Experimental", "home"})
local TabTestingTornado = Window:MakeTab({"Testing Tornado", "home"})

-- Seções
local SectionTestes = TabMain:AddSection({"Testes Annoy e Tornado"})
local SectionTornado = TabTestingTornado:AddSection({"Testes tornado"})

-- Variáveis
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Vehicles = workspace:WaitForChild("Vehicles")

local RE = ReplicatedStorage:WaitForChild("RE")
local ClearEvent = RE:FindFirstChild("1Clea1rTool1s")
local ToolEvent = RE:FindFirstChild("1Too1l")
local FireEvent = RE:FindFirstChild("1Gu1n")

-- Dropdown de jogadores
local PlayerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(PlayerNames, p.Name)
end

local selectedPlayerName = nil
local Dropdown = TabMain:AddDropdown({
    Name = "Selecionar Jogador",
    Description = "Escolha um jogador da lista",
    Options = PlayerNames,
    Default = PlayerNames[1] or "",
    Callback = function(Value)
        selectedPlayerName = Value
        print("Jogador selecionado:", Value)
    end
})

-- =====================
-- Funções Annoy do Wx
-- =====================
local FlingSystem = { power = 1e14, damage = 999999, interval = 0.02 }

local function clearTools()
    if ClearEvent then
        ClearEvent:FireServer("ClearAllTools")
    end
end

local function requestAssault()
    if ToolEvent then
        ToolEvent:InvokeServer("PickingTools", "Assault")
    end
end

local function hasWeapon()
    return Player.Backpack:FindFirstChild("Assault") or (Character and Character:FindFirstChild("Assault"))
end

local function equipWeapon()
    local weapon = Player.Backpack:FindFirstChild("Assault")
    if weapon and Character then
        local humanoid = Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(weapon)
            return true
        end
    end
    return false
end

local function getGunScript()
    if Character then
        local weapon = Character:FindFirstChild("Assault") or Player.Backpack:FindFirstChild("Assault")
        if weapon then
            return weapon:FindFirstChild("GunScript_Local")
        end
    end
    return nil
end

local function executeShot(targetPart)
    local gunScript = getGunScript()
    if not gunScript or not targetPart or not FireEvent then return end

    local args = {
        targetPart,
        targetPart,
        Vector3.new(FlingSystem.power, FlingSystem.power, FlingSystem.power),
        targetPart.Position,
        gunScript:FindFirstChild("MuzzleEffect"),
        gunScript:FindFirstChild("HitEffect"),
        0,
        0,
        { false },
        {
            FlingSystem.damage,
            Vector3.new(1000, 1000, 1000),
            BrickColor.new(29),
            0.25,
            Enum.Material.SmoothPlastic,
            0.25
        },
        true,
        false
    }

    FireEvent:FireServer(unpack(args))
end

local function getSelectedTarget()
    if not selectedPlayerName then return nil end
    local player = Players:FindFirstChild(selectedPlayerName)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and rootPart and humanoid.Health > 0 then
            return { player = player, part = rootPart }
        end
    end
    return nil
end

local function flingTarget()
    local target = getSelectedTarget()
    if target then
        executeShot(target.part)
        local head = target.player.Character:FindFirstChild("Head")
        if head then executeShot(head) end
        local torso = target.player.Character:FindFirstChild("Torso") or target.player.Character:FindFirstChild("UpperTorso")
        if torso then executeShot(torso) end
    end
end

local function maintainWeapon()
    if not hasWeapon() then
        clearTools()
        task.wait(0.1)
        requestAssault()
        task.wait(0.2)

        local attempts = 0
        while not hasWeapon() and attempts < 20 do
            task.wait(0.1)
            attempts = attempts + 1
        end

        if hasWeapon() then
            equipWeapon()
        end
    end
end

function AnnoyDoWx()
    maintainWeapon()
    task.spawn(function()
        while true do
            maintainWeapon()
            if hasWeapon() and getGunScript() then
                flingTarget()
            end
            task.wait(FlingSystem.interval)
        end
    end)
end

-- =====================
-- Função Tornado PirateFree
-- =====================
local function TornadoPirateFree()
    -- Aviso no chat
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(
            "[⚠️AVISO] UM TORNADO SURGIU! Cartola Hub by Esther"
        )
    end

    -- Áudio
    local selectedAudioID = 9068077052
    local function playAudio()
        local args = { workspace, selectedAudioID, 1 }
        for i = 1, 5 do
            if RE:FindFirstChild("1Gu1nSound1s") then
                RE["1Gu1nSound1s"]:FireServer(unpack(args))
            end

            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. tostring(selectedAudioID)
            sound.Parent = RootPart
            sound:Play()
            task.wait(1.5)
            sound:Destroy()
        end
    end

    -- Spawn do barco
    local function spawnBoat()
        RootPart.CFrame = CFrame.new(1754, -2, 58)
        task.wait(0.5)
        if RE:FindFirstChild("1Ca1r") then
            RE["1Ca1r"]:FireServer("PickingBoat", "PirateFree")
        end
        task.wait(1)
        return Vehicles:FindFirstChild(Player.Name .. "Car")
    end

    local PCar = spawnBoat()
    if not PCar then warn("Falha ao spawnar o barco") return end

    local Seat = PCar:FindFirstChild("Body") and PCar.Body:FindFirstChild("VehicleSeat")
    if not Seat then warn("Seat não encontrado") return end

    -- Sentar no assento
    repeat
        task.wait(0.1)
        RootPart.CFrame = Seat.CFrame * CFrame.new(0, 1, 0)
    until Humanoid.SeatPart == Seat

    -- Tocar áudio em paralelo
    task.spawn(playAudio)

    -- Ejetar após 4s
    task.delay(4, function()
        if Humanoid.SeatPart then Humanoid.Sit = false end
        RootPart.CFrame = CFrame.new(0,0,0)
    end)

    -- Flip loop
    if RE:FindFirstChild("1Player1sCa1r") then
        local RE_Flip = RE["1Player1sCa1r"]
        task.spawn(function()
            while PCar and PCar.Parent do
                RE_Flip:FireServer("Flip")
                task.wait(0.5)
            end
        end)
    end

    -- Movimento do barco
    local waypoints = {
        Vector3.new(-16, 0, -47),
        Vector3.new(-110, 0, -45),
        Vector3.new(16, 0, -55)
    }

    local currentIndex, nextIndex = 1, 2
    local moveSpeed = 15
    local rotationSpeed = math.rad(720)
    local progress, currentRotation = 0, 0

    local function lerpCFrame(a, b, t)
        return a:lerp(b, t)
    end

    RunService.Heartbeat:Connect(function(dt)
        if not (PCar and PCar.PrimaryPart) then return end
        local startPos = waypoints[currentIndex]
        local endPos = waypoints[nextIndex]
        progress = progress + (moveSpeed * dt) / (startPos - endPos).Magnitude
        if progress >= 1 then
            progress = 0
            currentIndex = nextIndex
            nextIndex = (nextIndex % #waypoints) + 1
        end
        local newPos = lerpCFrame(CFrame.new(startPos), CFrame.new(endPos), progress).p
        currentRotation = currentRotation + rotationSpeed * dt
        local cf = CFrame.new(newPos) * CFrame.Angles(0, currentRotation, 0)
        PCar:SetPrimaryPartCFrame(cf)
    end)
end

-- =====================
-- Botões no Hub
-- =====================
TabMain:AddButton({
    Name = "Ativar Annoy do Wx",
    Callback = function()
        if not selectedPlayerName then
            warn("Selecione um jogador primeiro!")
            return
        end
        print("Annoy do Wx ativado para: "..selectedPlayerName)
        AnnoyDoWx()
    end
})

TabTestingTornado:AddButton({
    Name = "Ativar Tornado PirateFree",
    Callback = function()
        TornadoPirateFree()
        print("Tornado PirateFree ativado!")
    end
})

TabMain:AddButton({
    Name = "Ativar Annoy + Tornado",
    Callback = function()
        if not selectedPlayerName then
            warn("Selecione um jogador primeiro!")
            return
        end
        print("Annoy do Wx + Tornado ativados para: "..selectedPlayerName)
        AnnoyDoWx()
        TornadoPirateFree()
    end
})

-- Seção informativa
TabExperimental:AddSection({"Script secreto (vazamento = ban)"})

-- Botão diretamente na aba
TabExperimental:AddButton({
    Name = "Spawn - Factory",
    Callback = function()
        local player = game.Players.LocalPlayer
        local targetPosition = Vector3.new(-37, 19, -145)

        if not player.Character or not player.Character:FindFirstChild("Humanoid") then
            player.CharacterAdded:Wait()
        end

        local character = player.Character
        local humanoid = character:WaitForChild("Humanoid")

        humanoid:MoveTo(targetPosition)
        humanoid.MoveToFinished:Wait()

        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

        local args1 = {6}
        Remotes:WaitForChild("Lot:Claim"):InvokeServer(unpack(args1))

        local args2 = {6, "001_Landmark"}
        Remotes:WaitForChild("Lot:BuildProperty"):FireServer(unpack(args2))

        print("Spawn da Factory Praça testing 001 executado!")
    end
})

-- Variáveis globais
local isUnbanActive = false
local HouseTab = Window:MakeTab({"Houses", "home"})
local SelectHouse = nil
local NoclipDoor = nil

-- Função para obter lista de casas
local function getHouseList()
    local Tabela = {}
    local lots = workspace:FindFirstChild("001_Lots")
    if lots then
        for _, House in ipairs(lots:GetChildren()) do
            if House.Name ~= "For Sale" and House:IsA("Model") then
                table.insert(Tabela, House.Name)
            end
        end
    end
    return Tabela
end

-- Dropdown para selecionar casas
pcall(function()
    HouseTab:AddDropdown({
        Name = "Selecione a Casa",
        Options = getHouseList(),
        Default = "...",
        Callback = function(Value)
            SelectHouse = Value
            if NoclipDoor then
                NoclipDoor:Set(false)
            end
            print("Casa selecionada: " .. tostring(Value))
        end
    })
end)

-- Função para atualizar a lista de casas
local function DropdownHouseUpdate()
    local Tabela = getHouseList()
    print("DropdownHouseUpdate called. Houses found:", #Tabela)
    pcall(function()
        HouseTab:ClearDropdown("Selecione a Casa") -- Tentar limpar dropdown, se suportado
        HouseTab:AddDropdown({
            Name = "Selecione a Casa",
            Options = Tabela,
            Default = "...",
            Callback = function(Value)
                SelectHouse = Value
                if NoclipDoor then
                    NoclipDoor:Set(false)
                end
            end
        })
    end)
end

-- Inicializar dropdown
pcall(DropdownHouseUpdate)

-- Botão para atualizar lista de casas
pcall(function()
    HouseTab:AddButton({
        Name = "Atualizar Lista de Casas",
        Callback = function()
            print("Atualizar Lista de Casas button clicked.")
            pcall(DropdownHouseUpdate)
        end
    })
end)

-- Botão para teleportar para casa
pcall(function()
    HouseTab:AddButton({
        Name = "Teleportar para Casa",
        Callback = function()
            local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
            if House and game.Players.LocalPlayer.Character then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(House.WorldPivot.Position)
            else
                print("Casa não encontrada: " .. tostring(SelectHouse))
            end
        end
    })
end)

-- Botão para teleportar para cofre
pcall(function()
    HouseTab:AddButton({
        Name = "Teleportar para Cofre",
        Callback = function()
            local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
            if House and House:FindFirstChild("HousePickedByPlayer") and game.Players.LocalPlayer.Character then
                local safe = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_Safe")
                if safe then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safe.WorldPivot.Position)
                else
                    print("Cofre não encontrado na casa: " .. tostring(SelectHouse))
                end
            else
                print("Casa não encontrada: " .. tostring(SelectHouse))
            end
        end
    })
end)

-- Toggle para atravessar porta
pcall(function()
    NoclipDoor = HouseTab:AddToggle({
        Name = "Atravessar Porta da Casa",
        Description = "",
        Default = false,
        Callback = function(Value)
            pcall(function()
                local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                if House and House:FindFirstChild("HousePickedByPlayer") then
                    local housepickedbyplayer = House.HousePickedByPlayer
                    local doors = housepickedbyplayer.HouseModel:FindFirstChild("001_HouseDoors")
                    if doors and doors:FindFirstChild("HouseDoorFront") then
                        for _, Base in ipairs(doors.HouseDoorFront:GetChildren()) do
                            if Base:IsA("BasePart") then
                                Base.CanCollide = not Value
                            end
                        end
                    end
                end
            end)
        end
    })
end)

-- Toggle para tocar campainha
pcall(function()
    HouseTab:AddToggle({
        Name = "Tocar Campainha",
        Description = "",
        Default = false,
        Callback = function(Value)
            getgenv().ChaosHubAutoSpawnDoorbellValue = Value
            spawn(function()
                while getgenv().ChaosHubAutoSpawnDoorbellValue do
                    local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                    if House and House:FindFirstChild("HousePickedByPlayer") then
                        local doorbell = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_DoorBell")
                        if doorbell and doorbell:FindFirstChild("TouchBell") then
                            pcall(function()
                                fireclickdetector(doorbell.TouchBell.ClickDetector)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })
end)

-- Toggle para bater na porta
pcall(function()
    HouseTab:AddToggle({
        Name = "Bater na Porta",
        Description = "",
        Default = false,
        Callback = function(Value)
            getgenv().ChaosHubAutoSpawnDoorValue = Value
            spawn(function()
                while getgenv().ChaosHubAutoSpawnDoorValue do
                    local House = workspace["001_Lots"]:FindFirstChild(tostring(SelectHouse))
                    if House and House:FindFirstChild("HousePickedByPlayer") then
                        local doors = House.HousePickedByPlayer.HouseModel:FindFirstChild("001_HouseDoors")
                        if doors and doors:FindFirstChild("HouseDoorFront") and doors.HouseDoorFront:FindFirstChild("Knock") then
                            pcall(function()
                                fireclickdetector(doors.HouseDoorFront.Knock.TouchBell.ClickDetector)
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    })
end)

pcall(function()
    HouseTab:AddSection({ Name = "Teleporte Para Casas" })
end)

-- Lista de casas para teletransporte
local casas = {
    ["Casa 1"] = Vector3.new(260.29, 4.37, 209.32),
    ["Casa 2"] = Vector3.new(234.49, 4.37, 228.00),
    ["Casa 3"] = Vector3.new(262.79, 21.37, 210.84),
    ["Casa 4"] = Vector3.new(229.60, 21.37, 225.40),
    ["Casa 5"] = Vector3.new(173.44, 21.37, 228.11),
    ["Casa 6"] = Vector3.new(-43, 21, -137),
    ["Casa 7"] = Vector3.new(-40, 36, -137),
    ["Casa 11"] = Vector3.new(-21, 40, 436),
    ["Casa 12"] = Vector3.new(155, 37, 433),
    ["Casa 13"] = Vector3.new(255, 35, 431),
    ["Casa 14"] = Vector3.new(254, 38, 394),
    ["Casa 15"] = Vector3.new(148, 39, 387),
    ["Casa 16"] = Vector3.new(-17, 42, 395),
    ["Casa 17"] = Vector3.new(-189, 37, -247),
    ["Casa 18"] = Vector3.new(-354, 37, -244),
    ["Casa 19"] = Vector3.new(-456, 36, -245),
    ["Casa 20"] = Vector3.new(-453, 38, -295),
    ["Casa 21"] = Vector3.new(-356, 38, -294),
    ["Casa 22"] = Vector3.new(-187, 37, -295),
    ["Casa 23"] = Vector3.new(-410, 68, -447),
    ["Casa 24"] = Vector3.new(-348, 69, -496),
    ["Casa 28"] = Vector3.new(-103, 12, 1087),
    ["Casa 29"] = Vector3.new(-730, 6, 808),
    ["Casa 30"] = Vector3.new(-245, 7, 822),
    ["Casa 31"] = Vector3.new(639, 76, -361),
    ["Casa 32"] = Vector3.new(-908, 6, -361),
    ["Casa 33"] = Vector3.new(-111, 70, -417),
    ["Casa 34"] = Vector3.new(230, 38, 569),
    ["Casa 35"] = Vector3.new(-30, 13, 2209)
}

-- Criar lista de nomes de casas ordenada
local casasNomes = {}
for nome, _ in pairs(casas) do
    table.insert(casasNomes, nome)
end

table.sort(casasNomes, function(a, b)
    local numA = tonumber(a:match("%d+")) or 0
    local numB = tonumber(b:match("%d+")) or 0
    return numA < numB
end)

-- Dropdown para teletransporte
pcall(function()
    HouseTab:AddDropdown({
        Name = "Selecionar Casa",
        Options = casasNomes,
        Callback = function(casaSelecionada)
            local player = game.Players.LocalPlayer
            if player and player.Character then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(casas[casaSelecionada])
            end
        end
    })
end)

-- carpós dropdown
pcall(function()
    HouseTab:AddLabel("Teleporte para a Casa que Quiser")
end)

-- Seção para Auto Unban
pcall(function()
    HouseTab:AddSection({ Name = "Auto Unban" })
end)

-- Toggle para Auto Unban
pcall(function()
    HouseTab:AddToggle({
        Name = "Auto Unban",
        Default = false,
        Callback = function(state)
            isUnbanActive = state
            if isUnbanActive then
                print("Auto Unban Activated")
                spawn(startAutoUnban)
            else
                print("Auto Unban Deactivated")
            end
        end
    })
end)

-- Label após Auto Unban
pcall(function()
    HouseTab:AddLabel("Autounban das houses by Esther")
end)

local Tab = Window:MakeTab({"Lag", "home"})
-- Shutdown Custom Section
local Section = Tab:AddSection({
    Name = "Shutdown"
})

-- Shutdown Server Button
Tab:AddButton({
    Name = "Shutdown",
    Callback = function()
        for m = 1, 495 do
            local args = {
                [1] = "PickingTools",
                [2] = "FireHose"
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Too1l"):InvokeServer(unpack(args))
            local args = {
                [1] = "FireHose",
                [2] = "DestroyFireHose"
            }
            game:GetService("Players").LocalPlayer.Backpack.FireHose.ToolSound:FireServer(unpack(args))
        end
        local oldcf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(999999999.414, -475, 999999999.414)
        local rootpart = game.Players.LocalPlayer.Character.HumanoidRootPart
        repeat wait() until rootpart.Parent == nil
        repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcf
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Script de Dupe",
            Text = "Shutdown Concluído, Agora Vai Desligar",
            Button1 = "Ok",
            Duration = 5
        })
        wait()
        for _, ergeg in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if ergeg.Name == "FireHose" then
                ergeg.Parent = game.Players.LocalPlayer.Character
            end
        end
        wait(0.2)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Script de Dupe",
            Text = "Iniciando duplicação, seja paciente",
            Button1 = "Ok",
            Duration = 5
        })
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9999, -475, 9999)
    end
})

-- Lag Laptop Section
local Section = Tab:AddSection({
    Name = "Lag"
})

-- Toggle State for Lag Laptop
local toggles = { LagLaptop = false }

-- Function to Simulate Normal Click
local function clickNormally(object)
    local clickDetector = object:FindFirstChildWhichIsA("ClickDetector")
    if clickDetector then
        fireclickdetector(clickDetector)
    end
end

-- Function to Lag Game with Laptop
local function lagarJogoLaptop(laptopPath, maxTeleports)
    if laptopPath then
        local teleportCount = 0
        while teleportCount < maxTeleports and toggles.LagLaptop do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = laptopPath.CFrame
            clickNormally(laptopPath)
            teleportCount = teleportCount + 1
            wait(0.0001)
        end
    else
        warn("Laptop não encontrado.")
    end
end

-- Lag Laptop Toggle
Tab:AddToggle({
    Name = "Lag",
    Default = false,
    Callback = function(state)
        toggles.LagLaptop = state
        if state then
            local laptopPath = workspace:FindFirstChild("WorkspaceCom"):FindFirstChild("001_GiveTools"):FindFirstChild("Laptop")
            if laptopPath then
                spawn(function()
                    lagarJogoLaptop(laptopPath, 999999999)
                end)
            else
                warn("Laptop não encontrado.")
            end
        else
            print("Lag com Laptop desativado.")
        end
    end
})

local CarTab = Window:MakeTab({"Carro", "home"})

-- Colors for RGB
local colors = {
    Color3.new(1, 0, 0),     -- Red
    Color3.new(0, 1, 0),     -- Green
    Color3.new(0, 0, 1),     -- Blue
    Color3.new(1, 1, 0),     -- Yellow
    Color3.new(1, 0, 1),     -- Magenta
    Color3.new(0, 1, 1),     -- Cyan
    Color3.new(0.5, 0, 0.5), -- Purple
    Color3.new(1, 0.5, 0)    -- Orange
}

-- Replicated Storage Service
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = replicatedStorage:WaitForChild("RE"):WaitForChild("1Player1sCa1r")

-- RGB Color Change Logic
local isColorChanging = false
local colorChangeCoroutine = nil

local function changeCarColor()
    while isColorChanging do
        for _, color in ipairs(colors) do
            if not isColorChanging then return end
            local args = {
                [1] = "PickingCarColor",
                [2] = color
            }
            remoteEvent:FireServer(unpack(args))
            wait(1)
        end
    end
end

CarTab:AddButton({
    Name = "Remove All Cars",
    Callback = function()
        local ofnawufn = false

        if ofnawufn == true then
            return
        end
        ofnawufn = true

        local cawwfer = "MilitaryBoatFree" -- Alterado para MilitaryBoatFree
        local oldcfffff = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1754, -2, 58) -- Coordenadas atualizadas
        wait(0.3)

        local args = {
            [1] = "PickingBoat", -- Alterado para PickingBoat
            [2] = cawwfer
        }

        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
        wait(1)

        local wrinfjn
        for _, errb in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"]:GetDescendants()) do
            if errb:IsA("VehicleSeat") then
                wrinfjn = errb
            end
        end

        repeat
            if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then return end
            if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
                if not game.Players.LocalPlayer.Character.Humanoid.SeatPart == wrinfjn then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                end
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame + Vector3.new(0,1,0)
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame + Vector3.new(0,-1,0)
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame + Vector3.new(0,0,2)
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = wrinfjn.CFrame * CFrame.new(2,0,0)
            task.wait()
        until game.Players.LocalPlayer.Character.Humanoid.SeatPart == wrinfjn

        for _, wifn in pairs(game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"]:GetDescendants()) do
            if wifn.Name == "PhysicalWheel" then
                wifn:Destroy()
            end
        end

        local FLINGED = Instance.new("BodyThrust", game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass)
        FLINGED.Force = Vector3.new(50000, 0, 50000)
        FLINGED.Name = "SUNTERIUM HUB FLING"
        FLINGED.Location = game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.Position

        for _, wvwvwasc in pairs(game.workspace.Vehicles:GetChildren()) do
            for _, ascegr in pairs(wvwvwasc:GetDescendants()) do
                if ascegr.Name == "VehicleSeat" then
                    local targetcar = ascegr
                    local tet = Instance.new("BodyVelocity", game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass)
                    tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
                    tet.P = 1250
                    tet.Velocity = Vector3.new(0,0,0)
                    tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
                    for m=1,25 do
                        local pos = {x=0, y=0, z=0}
                        pos.x = targetcar.Position.X
                        pos.y = targetcar.Position.Y
                        pos.z = targetcar.Position.Z
                        pos.x = pos.x + targetcar.Velocity.X / 2
                        pos.y = pos.y + targetcar.Velocity.Y / 2
                        pos.z = pos.z + targetcar.Velocity.Z / 2
                        if pos.y <= -200 then
                            game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(0,1000,0)
                        else
                            game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z))
                            task.wait()
                            game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) + Vector3.new(0,-2,0)
                            task.wait()
                            game.workspace.Vehicles[game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(0,0,2)
                            task.wait()
                            game.workspace.Vehicles[
                                game.Players.LocalPlayer.Name.."Car"].Chassis.Mass.CFrame = CFrame.new(Vector3.new(pos.x,pos.y,pos.z)) * CFrame.new(2,0,0)
                            task.wait()
                        end
                        task.wait()
                    end
                end
            end
        end

        task.wait()
        local args = {
            [1] = "DeleteAllVehicles"
        }
        game:GetService("ReplicatedStorage").RE:FindFirstChild("1Ca1r"):FireServer(unpack(args))
        game.Players.LocalPlayer.Character.Humanoid.Sit = false
        wait()
        local tet = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        tet.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        tet.P = 1250
        tet.Velocity = Vector3.new(0,0,0)
        tet.Name = "#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"
        wait(0.1)
        for m=1,2 do
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcfffff
        end
        wait(1)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcfffff
        wait()
        game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("#mOVOOEPF$#@F$#GERE..>V<<<<EW<V<<W"):Destroy()
        wait(0.2)
        ofnawufn = false
    end
})

CarTab:AddParagraph({"Informação:", "Use it two times if u need it!"})

CarTab:AddButton({
    Name = "Bring All Cars",
    Callback = function()
        for _, v in pairs(workspace.Vehicles:GetChildren()) do
            v:SetPrimaryPartCFrame(game.Players.LocalPlayer.Character:GetPrimaryPartCFrame())
        end
    end
})

local AdminTab = Window:MakeTab({"Admin", "home"})

AdminTab:AddButton({
    Name = "Annoy server 9e16 version",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer

        local RE = ReplicatedStorage:WaitForChild("RE")
        local ClearEvent = RE:FindFirstChild("1Clea1rTool1s")
        local ToolEvent = RE:FindFirstChild("1Too1l")
        local FireEvent = RE:FindFirstChild("1Gu1n")

        -- Limpa todas as ferramentas
        local function clearAllTools()
            if ClearEvent then
                ClearEvent:FireServer("ClearAllTools")
            end
        end

        -- Solicita a arma
        local function getAssault()
            if ToolEvent then
                ToolEvent:InvokeServer("PickingTools", "Assault")
            end
        end

        -- Verifica se a arma foi pega
        local function hasAssault()
            return LocalPlayer.Backpack:FindFirstChild("Assault") ~= nil
        end

        -- Dispara contra uma parte
        local function fireAtPart(targetPart)
            local gunScript = LocalPlayer.Backpack:FindFirstChild("Assault")
                and LocalPlayer.Backpack.Assault:FindFirstChild("GunScript_Local")

            if not gunScript or not targetPart then return end

            local args = {
                targetPart,
                targetPart,
                Vector3.new(9e16, 9e16, 9e16),
                targetPart.Position,
                gunScript:FindFirstChild("MuzzleEffect"),
                gunScript:FindFirstChild("HitEffect"),
                0,
                0,
                { false },
                {
                    25,
                    Vector3.new(1000, 1000, 1000),
                    BrickColor.new(29),
                    0.25,
                    Enum.Material.SmoothPlastic,
                    0.25
                },
                true,
                false
            }

            FireEvent:FireServer(unpack(args))
        end

        -- Atira em todos os jogadores
        local function fireAtAllPlayers(times)
            for i = 1, times do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        fireAtPart(player.Character.HumanoidRootPart)
                        task.wait(0.1)
                    end
                end
            end
        end

        -- Função principal em loop infinito até equipar a arma
        task.spawn(function()
            while true do
                clearAllTools()
                getAssault()

                repeat
                    task.wait(0.2)
                until hasAssault()

                fireAtAllPlayers(3)

                task.wait(1)
            end
        end)
    end
})

AdminTab:AddButton({
    Name = "Annoy the entire server! (1e14 version)",
    Callback = function()
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer

        local RE = ReplicatedStorage:WaitForChild("RE")
        local ClearEvent = RE:FindFirstChild("1Clea1rTool1s")
        local ToolEvent = RE:FindFirstChild("1Too1l")
        local FireEvent = RE:FindFirstChild("1Gu1n")

        -- Limpa todas as ferramentas
        local function clearAllTools()
            if ClearEvent then
                ClearEvent:FireServer("ClearAllTools")
            end
        end

        -- Solicita a arma
        local function getAssault()
            if ToolEvent then
                ToolEvent:InvokeServer("PickingTools", "Assault")
            end
        end

        -- Verifica se a arma foi pega
        local function hasAssault()
            return LocalPlayer.Backpack:FindFirstChild("Assault") ~= nil
        end

        -- Dispara contra uma parte
        local function fireAtPart(targetPart)
            local gunScript = LocalPlayer.Backpack:FindFirstChild("Assault")
                and LocalPlayer.Backpack.Assault:FindFirstChild("GunScript_Local")

            if not gunScript or not targetPart then return end

            local args = {
                targetPart,
                targetPart,
                Vector3.new(1e14, 1e14, 1e14),
                targetPart.Position,
                gunScript:FindFirstChild("MuzzleEffect"),
                gunScript:FindFirstChild("HitEffect"),
                0,
                0,
                { false },
                {
                    25,
                    Vector3.new(100, 100, 100),
                    BrickColor.new(29),
                    0.25,
                    Enum.Material.SmoothPlastic,
                    0.25
                },
                true,
                false
            }

            FireEvent:FireServer(unpack(args))
        end

        -- Atira em todos os jogadores
        local function fireAtAllPlayers(times)
            for i = 1, times do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        fireAtPart(player.Character.HumanoidRootPart)
                        task.wait(0.1)
                    end
                end
            end
        end

        -- Função principal em loop infinito até equipar a arma
        task.spawn(function()
            while true do
                clearAllTools()
                getAssault()

                repeat
                    task.wait(0.2)
                until hasAssault()

                fireAtAllPlayers(3)

                task.wait(1)
            end
        end)
    end
})
-- Lista de áudios
local audios = {
    {Name = "Yamete Kudasai", ID = 108494476595033},
    {Name = "Gritinho", ID = 5710016194},
    {Name = "Jumpscare Horroroso", ID = 85435253347146},
    {Name = "Áudio Alto", ID = 6855150757},
    {Name = "Ruído", ID = 120034877160791},
    {Name = "Jumpscare 2", ID = 110637995610528},
    {Name = "Risada Da Bruxa Minecraft", ID = 116214940486087},
    {Name = "The Boiled One", ID = 137177653817621}
}

local selectedAudioID

-- Adicionar uma textbox para inserir o ID do áudio
TabAudio:AddTextBox({
    Name = "Insira o ID do Áudio ou Musica",
    Description = "Digite o ID do áudio",
    PlaceholderText = "ID do áudio",
    Callback = function(value)
        selectedAudioID = tonumber(value)
    end
})

-- Adicionar uma dropdown para selecionar o áudio
local audioNames = {}
for _, audio in ipairs(audios) do
    table.insert(audioNames, audio.Name)
end

TabAudio:AddDropdown({
    Name = "Selecione o Áudio",
    Description = "Escolha um áudio da lista",
    Options = audioNames,
    Default = audioNames[1],
    Flag = "selected_audio",
    Callback = function(value)
        for _, audio in ipairs(audios) do
            if audio.Name == value then
                selectedAudioID = audio.ID
                break
            end
        end
    end
})

-- Controle do loop
local audioLoop = false

-- Nova seção para loop de áudio
TabAudio:AddSection({"Loop de Audio"})

-- Função para tocar o áudio repetidamente
local function playLoopedAudio()
    while audioLoop do
        if selectedAudioID then
            local args = {
                [1] = game:GetService("Workspace"),
                [2] = selectedAudioID,
                [3] = 1,
            }
            game:GetService("ReplicatedStorage").RE:FindFirstChild("1Gu1nSound1s"):FireServer(unpack(args))

            -- Criar e tocar o áudio
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://" .. selectedAudioID
            sound.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            sound:Play()
        else
            warn("Nenhum áudio selecionado!")
        end

        task.wait(0.5) -- Pequeno delay para evitar sobrecarga
    end
end

-- Toggle para loop de áudio
TabAudio:AddToggle({
    Name = "Loop Tocar Áudio",
    Description = "Ativa o loop do áudio",
    Default = false,
    Flag = "audio_loop",
    Callback = function(value)
        audioLoop = value
        if audioLoop then
            task.spawn(playLoopedAudio) -- Inicia o loop em uma nova thread
        end
    end
})
