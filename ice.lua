local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

local library = {}
local ThemeColor = Color3.fromRGB(255, 255, 255)

function library:CreateObject(class: string, properties: {}, parent: Instance)
	local Object: Instance = Instance.new(class)
	
	for i, property in pairs(properties) do
		Object[i] = property
	end
	
	if parent ~= nil then
		Object.Parent = parent
	end
	
	return Object
end

function library:SetDraggable(gui)
	local UserInputService = game:GetService("UserInputService")

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function library:RoundCorners(object: Instance, radius: number)
	return library:CreateObject("UICorner", {
		CornerRadius = UDim.new(0, radius)
	}, object)
end

function library.new(title: string)
	local menu = {}
	
	-- ScreenGui
	
	local ScreenGui = library:CreateObject("ScreenGui", {
		Name = title .. "ScreenGui",
		ResetOnSpawn = false
	}, Player.PlayerGui)
	
	-- Main frame
	
	local Main = library:CreateObject("Frame", {
		Name = title,
		BackgroundColor3 = Color3.fromRGB(50, 50, 50),
		Size = UDim2.new(0, 450, 0, 250)
	}, ScreenGui)
	
	library:RoundCorners(Main, 5)
	library:SetDraggable(Main)
	
	-- TopBar
	
	local TopBar = library:CreateObject("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Size = UDim2.new(1, 0, 0, 40)
	}, Main)	
		
	local CloseButton = library:CreateObject("TextButton", {
		Name = "Close",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 420, 0, 10),
		Size = UDim2.new(0, 20, 0, 20),
		Font = Enum.Font.SourceSans,
		Text = "X",
		TextColor3 = ThemeColor,
		TextScaled = true
	}, TopBar)
	
	library:CreateObject("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 9),
		Size = UDim2.new(0, 400, 0, 22),
		Font = Enum.Font.SourceSansSemibold,
		Text = title,
		TextColor3 = ThemeColor,
		TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left
	}, TopBar)
	
	library:RoundCorners(TopBar, 5)
	
	-- SideBar
	
	local SideBar = library:CreateObject("Frame", {
		Name = "SideBar",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, 120, 0, 210)
	}, Main)
	
	local TabContainer = library:CreateObject("Frame", {
		Name = "TabContainer",
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(0, 100, 0, 20)
	}, SideBar)
	
	library:CreateObject("Frame", {
		Name = "RoughEdges",
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, -5),
		Size = UDim2.new(0, 120, 0, 10)
	}, SideBar)
	
	library:CreateObject("UIListLayout", {
		Padding = UDim.new(0, 5)
	}, TabContainer)
	
	library:RoundCorners(SideBar, 5)
	
	-- Section
	
	function menu:CreateTabButton(text: string)
		local TabButton = library:CreateObject("TextButton", {
			Name = text,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 100, 0, 20),
			Font = Enum.Font.SourceSans,
			Text = text,
			TextColor3 = ThemeColor,
			TextScaled = true
		}, TabContainer)
	end
	
	function menu:CreateSection(name: string)
		local section = {}
		
		local SectionContainer = library:CreateObject("ScrollingFrame", {
			Name = "SectionContainer",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 130, 0, 50),
			Size = UDim2.new(0, 310, 0, 190),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 190),
			ScrollBarImageTransparency = 0.5,
			ScrollBarThickness = 6
		}, Main)
		
		library:CreateObject("UIListLayout", {
			Padding = UDim.new(0, 5)
		}, SectionContainer)
		
		menu:CreateTabButton(name)
		
		function section:CreateButton(text: string, callback)
			local Button = library:CreateObject("TextButton", {
				Name = text,
				BackgroundColor3 = Color3.fromRGB(40, 40, 40),
				Size = UDim2.new(0, 300, 0, 30),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextSize = 20
			}, SectionContainer)
			
			library:RoundCorners(Button, 5)
			
			Button.Activated:Connect(callback)
			
			return Button
		end
		
		function section:CreateTextLabel(text: string)
			return library:CreateObject("TextLabel", {
				Name = text .. "Label",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 300, 0, 20),
				Font = Enum.Font.SourceSans,
				Text = text,
				TextColor3 = ThemeColor,
				TextSize = 20,
			}, SectionContainer)
		end
		
		return section
	end
	
	return menu
end

return library
