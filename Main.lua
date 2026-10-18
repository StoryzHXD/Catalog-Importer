local AssetService = game:GetService("AssetService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Selection = game:GetService("Selection")
local TweenService = game:GetService("TweenService")

local PLUGIN_ID = "CatalogImporter_Toon_Icon_Dark_v3"
local DEFAULT_BUNDLE_ID = "52488952982257"
local TOOLBAR_NAME = "Catalog Tools"

local toolbar = plugin:CreateToolbar(TOOLBAR_NAME)
local toggleButton = toolbar:CreateButton(
	"OpenCatalogImporter",
	"Catalog Importer",
	"rbxassetid://117646564132740",
	"Catalog Importer"
)

toggleButton.ClickableWhenViewportHidden = true
toggleButton:SetActive(false)

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	false,
	410,
	390,
	350,
	370
)

local widget = plugin:CreateDockWidgetPluginGuiAsync(PLUGIN_ID, widgetInfo)
widget.Title = "Catalog Importer"

local palettes = {
	Dark = {
		background = Color3.fromRGB(10, 15, 28),
		panel = Color3.fromRGB(19, 29, 49),
		panelTop = Color3.fromRGB(28, 42, 68),
		panelBottom = Color3.fromRGB(17, 27, 46),
		field = Color3.fromRGB(14, 23, 41),
		fieldTop = Color3.fromRGB(22, 35, 58),
		fieldBottom = Color3.fromRGB(12, 21, 38),
		ink = Color3.fromRGB(4, 9, 20),
		text = Color3.fromRGB(244, 249, 255),
		muted = Color3.fromRGB(153, 173, 201),
		softStroke = Color3.fromRGB(55, 82, 119),
		blue = Color3.fromRGB(0, 157, 255),
		blueLight = Color3.fromRGB(72, 210, 255),
		purple = Color3.fromRGB(159, 83, 255),
		purpleLight = Color3.fromRGB(205, 125, 255),
		pink = Color3.fromRGB(255, 85, 161),
		yellow = Color3.fromRGB(255, 198, 51),
		mint = Color3.fromRGB(112, 255, 75),
		green = Color3.fromRGB(93, 229, 65),
		red = Color3.fromRGB(255, 90, 112),
		assetTop = Color3.fromRGB(25, 76, 111),
		assetBottom = Color3.fromRGB(16, 43, 68),
		bundleTop = Color3.fromRGB(79, 44, 109),
		bundleBottom = Color3.fromRGB(45, 31, 72),
		buttonSecondaryTop = Color3.fromRGB(37, 54, 81),
		buttonSecondaryBottom = Color3.fromRGB(23, 37, 61),
	},
	Light = {
		background = Color3.fromRGB(232, 241, 252),
		panel = Color3.fromRGB(250, 253, 255),
		panelTop = Color3.fromRGB(255, 255, 255),
		panelBottom = Color3.fromRGB(235, 244, 255),
		field = Color3.fromRGB(238, 246, 255),
		fieldTop = Color3.fromRGB(255, 255, 255),
		fieldBottom = Color3.fromRGB(226, 239, 255),
		ink = Color3.fromRGB(13, 25, 45),
		text = Color3.fromRGB(23, 39, 62),
		muted = Color3.fromRGB(91, 113, 143),
		softStroke = Color3.fromRGB(154, 182, 216),
		blue = Color3.fromRGB(0, 132, 235),
		blueLight = Color3.fromRGB(70, 183, 255),
		purple = Color3.fromRGB(130, 68, 222),
		purpleLight = Color3.fromRGB(184, 126, 255),
		pink = Color3.fromRGB(227, 65, 137),
		yellow = Color3.fromRGB(239, 169, 28),
		mint = Color3.fromRGB(75, 192, 54),
		green = Color3.fromRGB(48, 155, 47),
		red = Color3.fromRGB(207, 48, 70),
		assetTop = Color3.fromRGB(212, 239, 255),
		assetBottom = Color3.fromRGB(187, 224, 251),
		bundleTop = Color3.fromRGB(239, 221, 255),
		bundleBottom = Color3.fromRGB(221, 202, 250),
		buttonSecondaryTop = Color3.fromRGB(56, 78, 110),
		buttonSecondaryBottom = Color3.fromRGB(34, 51, 78),
	},
}

local savedTheme = nil
pcall(function()
	savedTheme = plugin:GetSetting("CatalogImporterTheme")
end)
local currentThemeName = savedTheme == "Light" and "Light" or "Dark"
local colors = {}
local function loadPalette(name)
	currentThemeName = name
	for key, value in pairs(palettes[name]) do
		colors[key] = value
	end
end
loadPalette(currentThemeName)

local function create(className, properties, parent)
	local object = Instance.new(className)
	for property, value in pairs(properties) do
		object[property] = value
	end
	object.Parent = parent
	return object
end

local function addCorner(parent, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 10) }, parent)
end

local function addStroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or colors.ink,
		Thickness = thickness or 1.5,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function addGradient(parent, first, second, rotation)
	return create("UIGradient", {
		Rotation = rotation or 0,
		Color = ColorSequence.new(first, second),
	}, parent)
end

local root = create("Frame", {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = colors.background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, widget)
local rootGradient = addGradient(root, colors.background, colors.panel, 90)

-- Compact, sticker-like interface inspired by the Catalog Importer icon.
local header = create("Frame", {
	Name = "Header",
	Position = UDim2.fromOffset(9, 8),
	Size = UDim2.new(1, -18, 0, 55),
	BackgroundColor3 = colors.blue,
	BorderSizePixel = 0,
}, root)
addCorner(header, 12)
local headerStroke = addStroke(header, colors.ink, 2.2, 0.02)
local headerGradient = addGradient(header, Color3.fromRGB(0, 185, 255), Color3.fromRGB(37, 84, 255), 18)

local logoBadge = create("Frame", {
	Name = "CatalogMark",
	Position = UDim2.fromOffset(8, 8),
	Size = UDim2.fromOffset(39, 39),
	BackgroundColor3 = Color3.fromRGB(9, 21, 42),
	BorderSizePixel = 0,
	Rotation = -3,
}, header)
addCorner(logoBadge, 10)
local logoStroke = addStroke(logoBadge, Color3.fromRGB(231, 247, 255), 1.8, 0.03)
local logoGradient = addGradient(logoBadge, Color3.fromRGB(30, 54, 90), Color3.fromRGB(10, 20, 39), 90)

local tileColors = {
	Color3.fromRGB(0, 185, 255),
	Color3.fromRGB(172, 67, 255),
	Color3.fromRGB(255, 177, 30),
	Color3.fromRGB(24, 224, 166),
}
for index, pos in ipairs({
	UDim2.fromOffset(6, 6),
	UDim2.fromOffset(20, 6),
	UDim2.fromOffset(6, 20),
	UDim2.fromOffset(20, 20),
	}) do
	local tile = create("Frame", {
		Name = "ItemTile" .. index,
		Position = pos,
		Size = UDim2.fromOffset(11, 11),
		BackgroundColor3 = tileColors[index],
		BorderSizePixel = 0,
	}, logoBadge)
	addCorner(tile, 3)
	addStroke(tile, colors.ink, 1, 0)
end
local logoArrow = create("TextLabel", {
	Name = "ImportArrow",
	Position = UDim2.new(1, -18, 0, -7),
	Size = UDim2.fromOffset(23, 28),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "↓",
	TextColor3 = colors.mint,
	TextSize = 27,
	TextStrokeColor3 = colors.ink,
	TextStrokeTransparency = 0.05,
	Rotation = 8,
}, logoBadge)

create("TextLabel", {
	Name = "Eyebrow",
	Position = UDim2.fromOffset(56, 7),
	Size = UDim2.new(1, -110, 0, 12),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "ROBLOX STUDIO TOOL",
	TextColor3 = Color3.fromRGB(216, 240, 255),
	TextSize = 8,
	TextXAlignment = Enum.TextXAlignment.Left,
}, header)
create("TextLabel", {
	Name = "TitleCatalog",
	Position = UDim2.fromOffset(55, 17),
	Size = UDim2.fromOffset(77, 25),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "CATALOG",
	TextColor3 = Color3.fromRGB(255, 205, 58),
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextStrokeColor3 = colors.ink,
	TextStrokeTransparency = 0.65,
}, header)
create("TextLabel", {
	Name = "TitleImporter",
	Position = UDim2.fromOffset(133, 17),
	Size = UDim2.new(1, -177, 0, 25),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "IMPORTER",
	TextColor3 = Color3.fromRGB(137, 255, 93),
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextStrokeColor3 = colors.ink,
	TextStrokeTransparency = 0.65,
}, header)

local themeButton = create("TextButton", {
	Name = "ThemeToggle",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -8, 0.5, 0),
	Size = UDim2.fromOffset(32, 32),
	BackgroundColor3 = Color3.fromRGB(12, 29, 58),
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBlack,
	Text = "☼",
	TextColor3 = Color3.fromRGB(255, 219, 91),
	TextSize = 20,
	Rotation = -5,
}, header)
addCorner(themeButton, 9)
local themeButtonStroke = addStroke(themeButton, Color3.fromRGB(225, 246, 255), 1.6, 0.02)

local categoryLabel = create("TextLabel", {
	Name = "CategoryLabel",
	Position = UDim2.fromOffset(12, 70),
	Size = UDim2.new(1, -24, 0, 13),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "CHOOSE A SOURCE",
	TextColor3 = colors.text,
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left,
}, root)

local function createCategoryTab(name, titleText, detailText, iconText, xScale, accent)
	local tab = create("TextButton", {
		Name = name,
		Position = UDim2.new(xScale, xScale == 0 and 10 or 4, 0, 87),
		Size = UDim2.new(0.5, -17, 0, 57),
		BackgroundColor3 = colors.panel,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Text = "",
	}, root)
	addCorner(tab, 11)
	local stroke = addStroke(tab, colors.softStroke, 1.5, 0.1)
	local gradient = addGradient(tab, colors.panelTop, colors.panelBottom, 90)
	local icon = create("Frame", {
		Name = "IconSticker",
		Position = UDim2.fromOffset(7, 9),
		Size = UDim2.fromOffset(38, 38),
		BackgroundColor3 = accent,
		BorderSizePixel = 0,
		Rotation = -4,
	}, tab)
	addCorner(icon, 9)
	addStroke(icon, colors.ink, 1.7, 0.02)
	addGradient(icon, accent:Lerp(Color3.new(1, 1, 1), 0.17), accent, 90)
	create("TextLabel", {
		Name = "IconText",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		Text = iconText,
		TextColor3 = colors.ink,
		TextSize = 15,
		Rotation = 4,
	}, icon)
	create("TextLabel", {
		Name = "TabTitle",
		Position = UDim2.fromOffset(52, 11),
		Size = UDim2.new(1, -59, 0, 17),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBlack,
		Text = titleText,
		TextColor3 = colors.text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, tab)
	create("TextLabel", {
		Name = "TabDetail",
		Position = UDim2.fromOffset(52, 29),
		Size = UDim2.new(1, -59, 0, 15),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = detailText,
		TextColor3 = colors.muted,
		TextSize = 8,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, tab)
	local selectedDot = create("Frame", {
		Name = "SelectedDot",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -6, 0, 6),
		Size = UDim2.fromOffset(7, 7),
		BackgroundColor3 = colors.mint,
		BorderSizePixel = 0,
		Visible = false,
	}, tab)
	addCorner(selectedDot, 10)
	addStroke(selectedDot, colors.ink, 0.9, 0.04)
	return tab, stroke, gradient, icon, selectedDot
end

local assetTab, assetTabStroke, assetTabGradient, assetTabIcon, assetSelectedDot = createCategoryTab(
	"AssetCategory", "ASSET", "Single catalog item", "A", 0, colors.blue
)
local bundleTab, bundleTabStroke, bundleTabGradient, bundleTabIcon, bundleSelectedDot = createCategoryTab(
	"BundleCategory", "BUNDLE", "Avatar / character set", "B", 0.5, colors.purple
)

local inputTitle = create("TextLabel", {
	Name = "InputTitle",
	Position = UDim2.fromOffset(12, 152),
	Size = UDim2.new(1, -24, 0, 14),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "BUNDLE ID OR URL",
	TextColor3 = colors.text,
	TextSize = 9,
	TextXAlignment = Enum.TextXAlignment.Left,
}, root)

local input = create("TextBox", {
	Name = "CatalogIdInput",
	Position = UDim2.fromOffset(10, 170),
	Size = UDim2.new(1, -20, 0, 38),
	BackgroundColor3 = colors.field,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamMedium,
	PlaceholderText = "Paste /bundles/ID or a bundle ID...",
	Text = DEFAULT_BUNDLE_ID,
	TextColor3 = colors.text,
	PlaceholderColor3 = colors.muted,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
}, root)
addCorner(input, 9)
local inputStroke = addStroke(input, colors.softStroke, 1.6, 0.04)
local inputGradient = addGradient(input, colors.fieldTop, colors.fieldBottom, 90)
create("UIPadding", { PaddingLeft = UDim.new(0, 11), PaddingRight = UDim.new(0, 11) }, input)

local actionRow = create("Frame", {
	Name = "Actions",
	Position = UDim2.fromOffset(10, 217),
	Size = UDim2.new(1, -20, 0, 40),
	BackgroundTransparency = 1,
}, root)

local function createButton(name, buttonText, color, parent, size, secondColor)
	local button = create("TextButton", {
		Name = name,
		Size = size,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBlack,
		Text = buttonText,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 10,
		TextWrapped = true,
	}, parent)
	addCorner(button, 10)
	local stroke = addStroke(button, colors.ink, 1.8, 0.02)
	local gradient = addGradient(button, secondColor or color:Lerp(Color3.new(1, 1, 1), 0.14), color:Lerp(Color3.new(0, 0, 0), 0.04), 90)
	local baseColor = color
	local baseSize = size
	local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	button.MouseEnter:Connect(function()
		if button.Active then
			TweenService:Create(button, tweenInfo, { BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.12) }):Play()
		end
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, tweenInfo, { BackgroundColor3 = baseColor }):Play()
	end)
	button.MouseButton1Down:Connect(function()
		if button.Active then
			TweenService:Create(button, TweenInfo.new(0.06), { Size = baseSize - UDim2.fromOffset(0, 2) }):Play()
		end
	end)
	button.MouseButton1Up:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.08), { Size = baseSize }):Play()
	end)
	return button, stroke, gradient
end

local inspectButton, inspectButtonStroke, inspectButtonGradient = createButton(
	"InspectButton", "⌕  INSPECT BUNDLE", colors.blue, actionRow,
	UDim2.new(0.5, -5, 1, -1), Color3.fromRGB(70, 210, 255)
)
inspectButton.Position = UDim2.fromOffset(0, 0)
local importRigButton, importButtonStroke, importButtonGradient = createButton(
	"ImportButton", "↓  CREATE RIG", colors.mint, actionRow,
	UDim2.new(0.5, -5, 1, -1), Color3.fromRGB(171, 255, 94)
)
importRigButton.Position = UDim2.new(0.5, 5, 0, 0)
importRigButton.TextColor3 = Color3.fromRGB(8, 31, 20)

local rawButton, rawButtonStroke, rawButtonGradient = createButton(
	"ImportPartsButton", "▦  IMPORT SOURCE ASSETS", colors.ink, root,
	UDim2.new(1, -20, 0, 32), colors.buttonSecondaryTop
)
rawButton.Position = UDim2.fromOffset(10, 267)
rawButton.TextSize = 9

local separator = create("Frame", {
	Name = "StatusDivider",
	Position = UDim2.fromOffset(10, 309),
	Size = UDim2.new(1, -20, 0, 1),
	BackgroundColor3 = colors.softStroke,
	BackgroundTransparency = 0.45,
	BorderSizePixel = 0,
}, root)

local statusPill = create("Frame", {
	Name = "StatusDot",
	Position = UDim2.fromOffset(13, 326),
	Size = UDim2.fromOffset(9, 9),
	BackgroundColor3 = colors.yellow,
	BorderSizePixel = 0,
}, root)
addCorner(statusPill, 10)
local statusPillStroke = addStroke(statusPill, colors.ink, 1, 0.05)

local statusText = create("TextLabel", {
	Name = "StatusText",
	Position = UDim2.fromOffset(29, 319),
	Size = UDim2.new(1, -39, 0, 54),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Ready — paste an asset or bundle ID.",
	TextColor3 = colors.muted,
	TextSize = 10,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
}, root)

local lastBundle = nil
local lastAsset = nil
local selectedCategory = "Bundle"
local busy = false
local statusTone = "idle"
local statusMessage = "Ready — paste an asset or bundle ID."
local function applyStatusStyle()
	local statusColor = colors.muted
	local dotColor = colors.yellow
	if statusTone == "success" then
		statusColor = colors.mint
		dotColor = colors.mint
	elseif statusTone == "error" then
		statusColor = colors.red
		dotColor = colors.red
	elseif statusTone == "asset" then
		statusColor = colors.blueLight
		dotColor = colors.blueLight
	elseif statusTone == "bundle" then
		statusColor = colors.purpleLight
		dotColor = colors.purpleLight
	end
	statusText.TextColor3 = statusColor
	statusPill.BackgroundColor3 = dotColor
	statusPillStroke.Color = colors.ink
end

local function renderCategoryStyle()
	local assetMode = selectedCategory == "Asset"
	assetTab.BackgroundColor3 = colors.panel
	bundleTab.BackgroundColor3 = colors.panel
	assetTabStroke.Color = assetMode and colors.blueLight or colors.softStroke
	bundleTabStroke.Color = not assetMode and colors.purpleLight or colors.softStroke
	assetTabStroke.Thickness = assetMode and 2.4 or 1.2
	bundleTabStroke.Thickness = not assetMode and 2.4 or 1.2
	assetTabStroke.Transparency = assetMode and 0 or 0.18
	bundleTabStroke.Transparency = not assetMode and 0 or 0.18
	assetTabGradient.Color = ColorSequence.new(
		assetMode and colors.assetTop or colors.panelTop,
		assetMode and colors.assetBottom or colors.panelBottom
	)
	bundleTabGradient.Color = ColorSequence.new(
		not assetMode and colors.bundleTop or colors.panelTop,
		not assetMode and colors.bundleBottom or colors.panelBottom
	)
	assetTabIcon.BackgroundColor3 = assetMode and colors.blueLight or Color3.fromRGB(34, 58, 86)
	bundleTabIcon.BackgroundColor3 = not assetMode and colors.purpleLight or Color3.fromRGB(49, 47, 82)
	assetSelectedDot.Visible = assetMode
	bundleSelectedDot.Visible = not assetMode
	assetTab:FindFirstChild("TabTitle").TextColor3 = colors.text
	bundleTab:FindFirstChild("TabTitle").TextColor3 = colors.text
	assetTab:FindFirstChild("TabDetail").TextColor3 = colors.muted
	bundleTab:FindFirstChild("TabDetail").TextColor3 = colors.muted
	assetTabIcon:FindFirstChild("IconText").TextColor3 = colors.ink
	bundleTabIcon:FindFirstChild("IconText").TextColor3 = colors.ink
	categoryLabel.TextColor3 = colors.text
	inputTitle.TextColor3 = colors.text
	input.BackgroundColor3 = colors.field
	input.TextColor3 = colors.text
	input.PlaceholderColor3 = colors.muted
	inputStroke.Color = colors.softStroke
	inputGradient.Color = ColorSequence.new(colors.fieldTop, colors.fieldBottom)
	separator.BackgroundColor3 = colors.softStroke
	rawButton.BackgroundColor3 = colors.ink
	rawButtonGradient.Color = ColorSequence.new(colors.buttonSecondaryTop, colors.buttonSecondaryBottom)
	rawButtonStroke.Color = colors.blue
	applyStatusStyle()
end

local function setTheme(themeName)
	local nextName = themeName == "Light" and "Light" or "Dark"
	loadPalette(nextName)
	local isDark = nextName == "Dark"
	root.BackgroundColor3 = colors.background
	rootGradient.Color = ColorSequence.new(colors.background, colors.panel)
	themeButton.Text = isDark and "☼" or "☾"
	themeButton.TextColor3 = isDark and Color3.fromRGB(255, 219, 91) or Color3.fromRGB(227, 246, 255)
	themeButton.BackgroundColor3 = isDark and Color3.fromRGB(12, 29, 58) or Color3.fromRGB(52, 102, 170)
	themeButtonStroke.Color = Color3.fromRGB(225, 246, 255)
	logoGradient.Color = isDark
		and ColorSequence.new(Color3.fromRGB(30, 54, 90), Color3.fromRGB(10, 20, 39))
		or ColorSequence.new(Color3.fromRGB(77, 145, 213), Color3.fromRGB(30, 71, 130))
	headerStroke.Color = colors.ink
	inputTitle.TextColor3 = colors.text
	categoryLabel.TextColor3 = colors.text
	statusText.TextColor3 = colors.muted
	renderCategoryStyle()
	if selectedCategory == "Asset" then
		inspectButton.Text = busy and "◌  PLEASE WAIT..." or "⌕  INSPECT ASSET"
		importRigButton.Text = busy and "◌  WORKING..." or "↓  IMPORT ASSET"
	else
		inspectButton.Text = busy and "◌  PLEASE WAIT..." or "⌕  INSPECT BUNDLE"
		importRigButton.Text = busy and "◌  WORKING..." or "↓  CREATE RIG"
	end
end

local function setStatus(message, color)
	statusMessage = tostring(message)
	statusText.Text = statusMessage
	if color == colors.green or color == colors.mint then
		statusTone = "success"
	elseif color == colors.red or color == colors.pink then
		statusTone = "error"
	elseif color == colors.blue or color == colors.blueLight then
		statusTone = "asset"
	elseif color == colors.purple or color == colors.purpleLight then
		statusTone = "bundle"
	else
		statusTone = "idle"
	end
	applyStatusStyle()
end

local function setCategory(category)
	if busy then
		return
	end

	selectedCategory = category == "Asset" and "Asset" or "Bundle"
	local assetMode = selectedCategory == "Asset"

	inputTitle.Text = assetMode and "ASSET ID OR URL" or "BUNDLE ID OR URL"
	input.PlaceholderText = assetMode and "Paste /catalog/ID or an asset ID..." or "Paste /bundles/ID or a bundle ID..."
	inspectButton.Text = assetMode and "⌕  INSPECT ASSET" or "⌕  INSPECT BUNDLE"
	importRigButton.Text = assetMode and "↓  IMPORT ASSET" or "↓  CREATE RIG"
	rawButton.Visible = not assetMode

	if assetMode and input.Text == DEFAULT_BUNDLE_ID then
		input.Text = ""
	elseif not assetMode and input.Text == "" then
		input.Text = DEFAULT_BUNDLE_ID
	end

	renderCategoryStyle()
	if assetMode then
		setStatus("Asset mode — paste a model, accessory, or compatible asset ID.", colors.blue)
	else
		setStatus("Bundle mode — inspect the bundle or create an avatar rig.", colors.purple)
	end
end

local function setBusy(value)
	busy = value
	inspectButton.Active = not value
	importRigButton.Active = not value
	rawButton.Active = not value
	assetTab.Active = not value
	bundleTab.Active = not value
	themeButton.Active = not value
	input.Active = not value
	inspectButton.Text = value and "◌  PLEASE WAIT..." or (selectedCategory == "Asset" and "⌕  INSPECT ASSET" or "⌕  INSPECT BUNDLE")
	importRigButton.Text = value and "◌  WORKING..." or (selectedCategory == "Asset" and "↓  IMPORT ASSET" or "↓  CREATE RIG")
	rawButton.Text = value and "LOADING ASSETS..." or "▦  IMPORT SOURCE ASSETS"
end

themeButton.Activated:Connect(function()
	local nextTheme = currentThemeName == "Dark" and "Light" or "Dark"
	setTheme(nextTheme)
	pcall(function()
		plugin:SetSetting("CatalogImporterTheme", nextTheme)
	end)
end)

local function parseBundleId(text)
	text = tostring(text or "")
	local id = string.match(text, "[Bb]undles/(%d+)")
	if not id then
		id = string.match(text, "^%s*(%d+)%s*$")
	end

	local number = tonumber(id)
	if number and number > 0 and number % 1 == 0 then
		return number
	end
	return nil
end

local function parseAssetId(text)
	text = tostring(text or "")
	local id = string.match(text, "[Cc]atalog/(%d+)")
		or string.match(text, "[Aa]ssets?/(%d+)")
		or string.match(text, "[Ll]ibrary/(%d+)")
	if not id then
		id = string.match(text, "^%s*(%d+)%s*$")
	end

	local number = tonumber(id)
	if number and number > 0 and number % 1 == 0 then
		return number
	end
	return nil
end

local function normalize(value)
	return string.lower(tostring(value or "")):gsub("[^%w]", "")
end

local BODY_PROPERTIES = {
	head = "Head",
	dynamichead = "Head",
	torso = "Torso",
	leftarm = "LeftArm",
	rightarm = "RightArm",
	leftleg = "LeftLeg",
	rightleg = "RightLeg",
}

local SINGLE_PROPERTIES = {
	face = "Face",
	shirt = "Shirt",
	classicshirt = "Shirt",
	pants = "Pants",
	classicpants = "Pants",
	tshirt = "GraphicTShirt",
	classictshirt = "GraphicTShirt",
}

local ACCESSORY_PROPERTIES = {
	hat = "HatAccessory",
	hataccessory = "HatAccessory",
	hairaccessory = "HairAccessory",
	faceaccessory = "FaceAccessory",
	neckaccessory = "NeckAccessory",
	shoulderaccessory = "ShouldersAccessory",
	shouldersaccessory = "ShouldersAccessory",
	frontaccessory = "FrontAccessory",
	backaccessory = "BackAccessory",
	waistaccessory = "WaistAccessory",
}

local function getAssetType(item)
	local assetType = normalize(item.AssetType)
	assetType = assetType:gsub("^enumavatarassettype", "")
	assetType = assetType:gsub("^avatarassettype", "")
	return assetType
end

local function inferBodyProperty(item)
	local assetType = getAssetType(item)
	local bodyProperty = BODY_PROPERTIES[assetType]
	if bodyProperty then
		return bodyProperty
	end

	local name = normalize(item.Name)
	for key, property in pairs(BODY_PROPERTIES) do
		if name == key or string.sub(name, -#key) == key then
			return property
		end
	end
	return nil
end

local function appendId(current, assetId)
	local id = tostring(assetId)
	current = tostring(current or "")
	if current == "" then
		return id
	end
	for existing in string.gmatch(current, "[^,]+") do
		if existing == id then
			return current
		end
	end
	return current .. "," .. id
end

local function getBundleDetails(bundleId)
	local bundle = AssetService:GetBundleDetailsAsync(bundleId)
	if type(bundle) ~= "table" then
		error("Roblox returned invalid details for this bundle.")
	end
	bundle.Items = bundle.Items or {}
	lastBundle = bundle
	return bundle
end

local getImportCFrame

local function getAssetDetails(assetId)
	local info = MarketplaceService:GetProductInfoAsync(assetId, Enum.InfoType.Asset)
	if type(info) ~= "table" then
		error("Roblox returned invalid details for this asset.")
	end

	lastAsset = info
	return info
end

local function importAsset(assetId)
	local productInfo
	local infoSuccess, infoOrError = pcall(function()
		return MarketplaceService:GetProductInfoAsync(assetId, Enum.InfoType.Asset)
	end)
	if infoSuccess then
		productInfo = infoOrError
	end

	local success, loadedOrError = pcall(function()
		return AssetService:LoadAssetAsync(assetId)
	end)
	if not success or not loadedOrError then
		error("Could not load asset " .. tostring(assetId) .. ". Make sure this asset type can be loaded and third-party asset loading is allowed. Details: " .. tostring(loadedOrError))
	end

	local model = loadedOrError
	local modelName = (productInfo and productInfo.Name) or ("Asset_" .. tostring(assetId))
	model.Name = tostring(modelName)
	model:PivotTo(getImportCFrame())
	model.Parent = workspace
	Selection:Set({ model })

	if productInfo then
		lastAsset = productInfo
	end

	return model, modelName, productInfo
end

getImportCFrame = function()
	local camera = workspace.CurrentCamera
	if camera then
		local position = camera.CFrame.Position + camera.CFrame.LookVector * 12
		return CFrame.new(position)
	end
	return CFrame.new(0, 5, 0)
end

local function buildDescriptionFromBundle(bundle)
	local outfitId = nil
	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "useroutfit" then
			outfitId = tonumber(item.Id)
			break
		end
	end

	if outfitId then
		local description = Players:GetHumanoidDescriptionFromOutfitIdAsync(outfitId)
		return description, "UserOutfit " .. tostring(outfitId)
	end

	local description = Instance.new("HumanoidDescription")
	local bodyCount = 0
	local mappedCount = 0
	local ignored = {}

	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "asset" and tonumber(item.Id) then
			local assetId = tonumber(item.Id)
			local bodyProperty = inferBodyProperty(item)
			local assetType = getAssetType(item)

			if bodyProperty then
				if description[bodyProperty] == 0 then
					description[bodyProperty] = assetId
					bodyCount = bodyCount + 1
					mappedCount = mappedCount + 1
				end
			else
				local singleProperty = SINGLE_PROPERTIES[assetType]
				local accessoryProperty = ACCESSORY_PROPERTIES[assetType]

				if singleProperty then
					description[singleProperty] = assetId
					mappedCount = mappedCount + 1
				elseif accessoryProperty then
					description[accessoryProperty] = appendId(description[accessoryProperty], assetId)
					mappedCount = mappedCount + 1
				else
					table.insert(ignored, tostring(item.Name or item.Id))
				end
			end
		end
	end

	if bodyCount == 0 then
		description:Destroy()
		local examples = table.concat(ignored, ", ")
		if examples == "" then
			examples = "no compatible body parts were found"
		end
		error("This bundle has no UserOutfit, and compatible body parts could not be identified. " .. examples)
	end

	return description, string.format("%d body part(s), %d item(s) mapped", bodyCount, mappedCount)
end

local function importAsRig(bundleId)
	local bundle = getBundleDetails(bundleId)
	local description, source = buildDescriptionFromBundle(bundle)
	local success, modelOrError = pcall(function()
		return Players:CreateHumanoidModelFromDescriptionAsync(
			description,
			Enum.HumanoidRigType.R15
		)
	end)
	description:Destroy()

	if not success then
		error("Roblox could not generate the R15 rig: " .. tostring(modelOrError))
	end

	local model = modelOrError
	model.Name = tostring(bundle.Name or ("Bundle_" .. tostring(bundleId)))
	model:PivotTo(getImportCFrame())
	model.Parent = workspace
	Selection:Set({ model })

	return model, source, bundle
end

local function importPartsSeparately(bundleId)
	local bundle = getBundleDetails(bundleId)
	local assetItems = {}

	for _, item in ipairs(bundle.Items) do
		if normalize(item.Type) == "asset" and tonumber(item.Id) then
			table.insert(assetItems, item)
		end
	end

	if #assetItems == 0 then
		error("This bundle has no Asset items to import separately.")
	end

	local folder = Instance.new("Folder")
	folder.Name = tostring(bundle.Name or ("Bundle_" .. tostring(bundleId))) .. " - Source Assets"
	folder.Parent = workspace

	local baseCFrame = getImportCFrame()
	local successes = 0
	local failures = {}

	for index, item in ipairs(assetItems) do
		setStatus(string.format("Loading asset %d of %d: %s", index, #assetItems, tostring(item.Name or item.Id)))
		local success, loadedOrError = pcall(function()
			return AssetService:LoadAssetAsync(tonumber(item.Id))
		end)

		if success and loadedOrError then
			local loaded = loadedOrError
			loaded.Name = tostring(item.Name or ("Asset_" .. tostring(item.Id)))
			loaded.Parent = folder
			if loaded:IsA("Model") then
				loaded:PivotTo(baseCFrame * CFrame.new((successes % 3) * 5, 0, math.floor(successes / 3) * 5))
			end
			successes = successes + 1
		else
			table.insert(failures, tostring(item.Name or item.Id) .. ": " .. tostring(loadedOrError))
		end
	end

	if successes == 0 then
		folder:Destroy()
		error("No assets could be loaded. Check that 'Allow Loading Third Party Assets' is enabled in Game Settings > Security. " .. table.concat(failures, " | "))
	end

	Selection:Set({ folder })
	return folder, successes, #assetItems, failures, bundle
end

local function getInputCatalogId()
	local catalogId
	if selectedCategory == "Asset" then
		catalogId = parseAssetId(input.Text)
		if not catalogId then
			error("Enter a numeric ID or a catalog URL containing /catalog/ID.")
		end
	else
		catalogId = parseBundleId(input.Text)
		if not catalogId then
			error("Enter a numeric ID or a URL containing /bundles/ID.")
		end
	end
	return catalogId
end

local function runAction(button, callback)
	if busy then
		return
	end

	local ok, catalogIdOrError = pcall(getInputCatalogId)
	if not ok then
		setStatus(catalogIdOrError, colors.red)
		return
	end

	setBusy(true)
	setStatus(selectedCategory == "Asset" and "Looking up catalog asset..." or "Looking up Roblox bundle...")

	task.spawn(function()
		local categoryAtStart = selectedCategory
		local success, resultA, resultB, resultC, resultD, resultE = pcall(callback, catalogIdOrError)
		if success then
			if button == inspectButton then
				if categoryAtStart == "Asset" then
					setStatus(string.format("Asset found: %s  |  ID %s", tostring(resultA.Name or "Untitled"), tostring(resultA.AssetId or catalogIdOrError)), colors.green)
				else
					setStatus(string.format("Bundle found: %s  |  %d item(s)", tostring(resultA.Name or "Untitled"), #(resultA.Items or {})), colors.green)
				end
			elseif button == importRigButton and categoryAtStart == "Asset" then
				setStatus("Asset imported: " .. tostring(resultB or resultA.Name), colors.green)
			elseif button == importRigButton then
				setStatus("Rig imported: " .. resultA.Name .. "\nSource: " .. tostring(resultB), colors.green)
			elseif button == rawButton then
				local message = string.format("Imported %d of %d source asset(s).\nThese parts are not automatically assembled into a rig.", resultB, resultC)
				if resultD and #resultD > 0 then
					message = message .. "\nFailures: " .. tostring(#resultD) .. " (see Output)."
					for _, failure in ipairs(resultD) do
						warn("[Catalog Importer] " .. failure)
					end
				end
				setStatus(message, colors.green)
			end
		else
			warn("[Catalog Importer] " .. tostring(resultA))
			setStatus(tostring(resultA), colors.red)
		end

		setBusy(false)
	end)
end

assetTab.Activated:Connect(function()
	setCategory("Asset")
end)

bundleTab.Activated:Connect(function()
	setCategory("Bundle")
end)

inspectButton.Activated:Connect(function()
	runAction(inspectButton, function(catalogId)
		if selectedCategory == "Asset" then
			return getAssetDetails(catalogId)
		end
		return getBundleDetails(catalogId)
	end)
end)

importRigButton.Activated:Connect(function()
	if selectedCategory == "Asset" then
		runAction(importRigButton, importAsset)
	else
		runAction(importRigButton, importAsRig)
	end
end)

rawButton.Activated:Connect(function()
	runAction(rawButton, importPartsSeparately)
end)

setTheme(currentThemeName)
setCategory("Bundle")

toggleButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
	toggleButton:SetActive(widget.Enabled)
end)

widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	toggleButton:SetActive(widget.Enabled)
end)

plugin.Unloading:Connect(function()
	if widget then
		widget:Destroy()
	end
end)
