# Catalog Importer

**Browse. Inspect. Import.**

Catalog Importer is a Roblox Studio plugin for inspecting catalog assets and avatar bundles, and importing compatible content into your current place. It features a colorful, cartoon-inspired interface with Dark and Light themes.

> **Compatibility note:** Importing depends on Roblox API availability, the asset type, ownership/sharing permissions, and whether the item can be loaded as a model. Not every catalog item can be imported, and generated character rigs may not preserve custom joints or every UGC-specific detail.

## Features

- **Asset mode** — Inspect an individual catalog asset and attempt to load it into `Workspace`.
- **Bundle mode** — Inspect bundle contents, create an R15 rig when a supported outfit or body-part mapping is available, or load source assets separately for inspection.
- **Asset details** — Display available catalog metadata and IDs.
- **Automatic placement** — Place imported content in front of the Studio camera and select it in Studio.
- **Dark and Light themes** — Switch themes; the preference is saved when Studio plugin settings are available.
- **Compact UI** — A cartoon-inspired interface with bright accents, gradients, and bold outlines.

## Installation

### Install as a local plugin

1. Download `CatalogImporter.plugin.lua` from this repository.
2. Open Roblox Studio and create a temporary `Script` in `ServerStorage`.
3. Copy the contents of `CatalogImporter.plugin.lua` into that Script.
4. Select the Script and choose **Plugins → Save as Local Plugin**.
5. After saving, remove the temporary Script from `ServerStorage`.
6. Open **Catalog Tools → Catalog Importer** from the Studio toolbar.

## Usage

### Import an asset

1. Open Catalog Importer and select **ASSET**.
2. Enter an asset ID or a supported catalog URL containing `/catalog/ID`, `/asset/ID`, `/assets/ID`, or `/library/ID`.
3. Select **INSPECT ASSET** to look up available metadata.
4. Select **IMPORT ASSET** to attempt to load the asset into `Workspace`.

### Import a bundle

1. Select **BUNDLE**. The Blocky Fingers bundle ID (`52488952982257`) is prefilled as an example.
2. Enter a bundle ID or a URL containing `/bundles/ID`.
3. Select **INSPECT BUNDLE** to query the bundle contents.
4. Select **CREATE RIG** to attempt to generate an R15 character from a supported `UserOutfit` or recognized body-part mapping.
5. Select **IMPORT SOURCE ASSETS** to attempt to load individual source assets for inspection. These assets are **not automatically assembled into a working rig**.

Use the sun/moon button in the header to switch between Dark and Light themes.

## Limitations and troubleshooting

- This plugin uses Roblox Studio APIs; results may vary by asset type and availability.
- `AssetService:LoadAssetAsync()` may fail for private, restricted, unavailable, unsupported, or unshared assets. Third-party asset loading permissions may apply.
- A bundle may not expose a `UserOutfit` or body-part data the plugin knows how to map.
- An automatically generated R15 rig is not guaranteed to preserve custom joints, articulated fingers, or every bundle-specific feature.
- If an operation fails, read the plugin's status message and check the Studio **Output** window for additional details.

## Project structure

```text
CatalogImporter.plugin.lua   # Plugin source
README.md                    # Project documentation
README.txt                   # Plain-text installation notes
```

## Contributing

Bug reports and improvements are welcome. Please include the asset or bundle type, the steps to reproduce the issue, and any relevant message from Studio's Output window. Avoid sharing private or restricted asset content.

## License

No license has been specified yet. Unless a license is added to this repository, reuse and redistribution permissions are not explicitly granted.