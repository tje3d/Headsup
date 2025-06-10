# Changelog

All notable changes to the Headsup addon will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-06-10

### ✨ Added
- **Buff Stacking Display**: New feature that intelligently shows stack counts for stackable buffs
  - Automatic detection of buff stacks using `UnitAura` API
  - Stack count appears in bottom-right corner of buff icons
  - Only displays when stack count > 1 to avoid visual clutter
  - Consistent font sizing with timer text
  - Memory efficient implementation
- **New Testing Command**: `/headsup teststack` command to test stack count display
  - Creates mock Arcane Concentration buff with 5 stacks
  - Useful for previewing the stack count feature
- **Enhanced GUI Testing**: Updated GUI test button to include stack count demonstration
  - Added Maelstrom Weapon test case with 3 stacks
  - Provides comprehensive testing of the new feature

### 🔧 Enhanced
- **Buff Detection**: Improved `ScanExistingBuffs` function to capture stack counts
- **Buff Display**: Enhanced `ShowBuff` function to handle stack count updates
- **Font Management**: Updated `UpdateFontSizes` to include stack count text
- **Code Documentation**: Added comprehensive inline documentation for new features

### 📚 Documentation
- Updated README.md with Buff Stacking Display feature documentation
- Added new command to Commands Reference table
- Enhanced Advanced Configuration section with detailed feature explanation
- Updated addon description in .toc file to mention stack counts
- Version bump from 1.0 to 1.1

## [1.0.0] - 2025-06-09

### 🎉 Initial Release
- **Core Functionality**: Display important buffs in the center of the screen
- **Multi-Class Support**: Comprehensive spell tracking for all WotLK classes
  - Death Knight: Killing Machine, Rime, Cinderglacier, Desolation, Unholy Force
  - Druid: Eclipse (Solar/Lunar), Nature's Grace, Predator's Swiftness, Omen of Clarity
  - Hunter: Improved Steady Shot, Lock and Load, Rapid Killing
  - Mage: Arcane Concentration, Brain Freeze, Fingers of Frost, Hot Streak, Missile Barrage
  - Paladin: Art of War, Infusion of Light
  - Priest: Surge of Light, Serendipity, Empowered Renew
  - Shaman: Elemental Focus, Maelstrom Weapon, Tidal Waves
  - Warlock: Backdraft, Decimation, Molten Core, Nightfall
  - Warrior: Bloodsurge, Sudden Death, Sword and Board, Taste for Blood
  - Trinkets and other procs

### 🎨 Customization Features
- **Flexible Positioning**: Adjustable vertical offset (-400 to 400 pixels)
- **Icon Sizing**: Configurable icon size (8-128 pixels)
- **Spacing Control**: Adjustable spacing between icons (0-50 pixels)
- **Font Options**: Customizable timer and spell name font sizes (6-24)
- **Spell Names**: Optional spell name display below icons

### 🔊 Audio System
- **Sound Notifications**: Audio alerts for new buff applications
- **Custom Sounds**: Support for custom sound files
- **Smart Alerts**: No spam on buff refreshes, only new applications
- **Sound Testing**: Built-in sound testing functionality

### ⚙️ Professional GUI
- **AceConfig Integration**: Modern configuration interface with sliders and toggles
- **Spell Management**: Add/remove custom spells with live preview
- **Real-time Updates**: All changes apply immediately without reload
- **Spell List Browser**: Scrollable list with spell icons, names, and tooltips
- **Reset Functionality**: Easy reset to default spell tracking

### 🛠️ Command System
- **Comprehensive Commands**: Full command-line interface for all features
- **Quick Access**: `/headsup` or `/hu` for command help
- **Configuration**: `/headsup config` for GUI access
- **Testing**: `/headsup test` for preview functionality
- **Spell Management**: Commands for adding/removing tracked spells

### 🎯 Core Features
- **Frame-Perfect Detection**: Precise buff tracking using combat log events
- **Automatic Positioning**: Smart horizontal positioning of multiple buffs
- **Duration Tracking**: Accurate countdown timers with multiple time formats
- **Memory Efficient**: Lightweight implementation with minimal performance impact
- **WotLK Compatible**: Full compatibility with World of Warcraft 3.3.5a

### 📋 Technical Implementation
- **Event-Driven Architecture**: Efficient combat log parsing
- **Saved Variables**: Persistent configuration storage
- **Error Handling**: Robust error handling and fallback mechanisms
- **Modular Design**: Clean separation of core logic and GUI components
- **Performance Optimized**: Minimal CPU and memory footprint

---

## Legend

- ✨ **Added**: New features
- 🔧 **Enhanced**: Improvements to existing features
- 🐛 **Fixed**: Bug fixes
- 📚 **Documentation**: Documentation updates
- 🎉 **Major**: Major releases or milestones
- ⚠️ **Deprecated**: Features that will be removed
- 🗑️ **Removed**: Removed features
- 🔒 **Security**: Security improvements