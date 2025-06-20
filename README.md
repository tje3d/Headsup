# 🎯 Headsup

> **The ultimate buff tracking addon for World of Warcraft: Wrath of the Lich King 3.3.5a**

[![Latest Release](https://img.shields.io/github/v/release/tje3d/Headsup?style=for-the-badge&color=00d4aa)](https://github.com/tje3d/Headsup/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/tje3d/Headsup/total?style=for-the-badge&color=1e90ff)](https://github.com/tje3d/Headsup/releases)
[![License](https://img.shields.io/github/license/tje3d/Headsup?style=for-the-badge&color=orange)](LICENSE)

## ✨ What is Headsup?

Headsup transforms your gameplay by displaying crucial buffs and procs **right in the center of your screen** where you need them most. No more glancing at buff bars or missing that perfect moment to unleash your abilities!

## 📸 Screenshots

<div align="center">

### 🎨 Customizable Display Options

![Headsup in Action](images/1.png)

### ⚙️ Professional Configuration Interface

![Configuration GUI](images/2.png)

### 🎯 Buff Tracking in Action

![Customization Options](images/3.png)

</div>

## 🚀 Quick Start

### 📥 Download & Install

**[⬇️ Download Latest Release](https://github.com/tje3d/Headsup/releases/latest/download/Headsup.zip)**

1. Download the latest release
2. Extract to your `World of Warcraft/Interface/AddOns/` folder
3. Restart WoW or reload UI (`/reload`)
4. Type `/headsup` to configure!

### 🎮 Instant Setup

```
/headsup config  # Open the beautiful GUI (see screenshot above)
/headsup test    # See it in action with test buffs
```

## 🌟 Key Features

### 🎯 **Perfect Positioning**

- Displays buffs in the **center of your screen**
- Fully customizable position and size
- Never miss a proc again!

### ⚡ **Smart Tracking**

- **All classes supported** with optimal proc tracking
- **Custom spell support** - add any spell ID
- **Automatic duration tracking** with precise timers
- **Buff stacking display** - shows stack counts for stackable buffs
- **Flash effect** - visual alerts when buffs are about to expire

### 🎨 **Beautiful & Customizable**

- Modern, clean interface
- Adjustable icon sizes (8-128px)
- Customizable spacing and fonts
- Optional spell names display

### 🔊 **Audio & Visual Alerts**

- Sound alerts for new procs
- Flash effect for expiring buffs
- Multiple sound options
- No spam on refreshes

### ⚙️ **Professional GUI**

- Easy-to-use configuration panel with sliders and toggles
- Live spell management with search and tooltips
- Real-time preview of all changes
- Comprehensive sound and display options

## 📋 Supported Spells

<details>
<summary><strong>🗡️ Death Knight</strong></summary>

- Killing Machine
- Rime (Freezing Fog)
- Cinderglacier
- Desolation
- Unholy Force & Strength
</details>

<details>
<summary><strong>🌿 Druid</strong></summary>

- Eclipse (Solar & Lunar)
- Nature's Grace
- Predator's Swiftness
- Omen of Clarity
- Owlkin Frenzy
</details>

<details>
<summary><strong>🏹 Hunter</strong></summary>

- Improved Steady Shot
- Lock and Load
- Rapid Killing
</details>

<details>
<summary><strong>🔥 Mage</strong></summary>

- Arcane Concentration
- Brain Freeze
- Fingers of Frost
- Hot Streak
- Missile Barrage
- And more!
</details>

<details>
<summary><strong>⚡ Shaman</strong></summary>

- Elemental Focus
- Maelstrom Weapon
- Tidal Waves
</details>

<details>
<summary><strong>🛡️ All Other Classes</strong></summary>

**Paladin, Priest, Warlock, Warrior** - comprehensive proc tracking for optimal DPS and healing rotations!

</details>

## 🛠️ Commands Reference

| Command                       | Description              |
| ----------------------------- | ------------------------ |
| `/headsup` or `/hu`           | Show all commands        |
| `/headsup config`             | Open configuration GUI   |
| `/headsup test`               | Display test buffs       |
| `/headsup teststack`          | Test buff with stacks    |
| `/headsup testflash`          | Test flash effect        |
| `/headsup toggle`             | Enable/disable addon     |
| `/headsup size <8-128>`       | Set icon size            |
| `/headsup spacing <0-50>`     | Set icon spacing         |
| `/headsup yoffset <-400-400>` | Set vertical position    |
| `/headsup flash`              | Toggle flash effect      |
| `/headsup flashtime <1-30>`   | Set flash threshold      |
| `/headsup flashspeed <0.1-2>` | Set flash speed          |
| `/headsup addspell <spellID>` | Add custom spell         |
| `/headsup listspells`         | Show tracked spells      |

## 🎯 Perfect For

- **Competitive Raiders** seeking every advantage
- **PvP Enthusiasts** who need split-second reactions
- **Casual Players** wanting to improve their gameplay
- **Alt Characters** learning new rotations

## 🔧 Advanced Configuration

### Buff Stacking Display

Headsup now intelligently displays stack counts for stackable buffs like Maelstrom Weapon, Serendipity, and other multi-stack abilities:

- **Automatic detection** - Stack counts appear automatically when buffs have multiple stacks
- **Clean display** - Only shows when stacks > 1 to avoid clutter
- **Perfect positioning** - Stack count appears in bottom-right corner of buff icon
- **Testing support** - Use `/headsup teststack` to preview the feature

### Custom Spell Tracking

```
/headsup addspell 12345    # Add any spell by ID
/headsup removespell 12345 # Remove from tracking
/headsup resetspells       # Reset to defaults
```

### Flash Effect Setup

```
/headsup flash                 # Toggle flash effect on/off
/headsup flashtime 5           # Flash when 5 seconds left
/headsup flashspeed 0.3        # Flash every 0.3 seconds
/headsup testflash             # Test flash effect
```

### Audio Setup

```
/headsup sound            # Toggle sound on/off
/headsup setsound <file>  # Set custom sound
/headsup testsound        # Test current sound
```

## 🆘 Support & Feedback

- 🐛 **Found a bug?** [Report it here](https://github.com/tje3d/Headsup/issues)
- 💡 **Feature request?** [Suggest it here](https://github.com/tje3d/Headsup/issues)
- 💬 **Need help?** Check our [Wiki](https://github.com/tje3d/Headsup/wiki) or open an issue

## 📊 Stats

- ⚡ **Lightweight** - Minimal performance impact
- 🎯 **Precise** - Frame-perfect buff detection
- 🔄 **Reliable** - Battle-tested in raids and PvP
- 🎨 **Beautiful** - Modern, clean interface

## 🏆 Why Choose Headsup?

> _"Game-changing addon! I never miss my procs anymore and my DPS has noticeably improved."_  
> – Top raider testimonial

> _"The GUI is incredible - so easy to customize exactly how I want it."_  
> – Happy user review

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Show Your Support

If Headsup improved your gameplay, **please star this repository!** It helps other players discover this awesome addon.

---

<div align="center">

**[⬇️ Download Now](https://github.com/tje3d/Headsup/releases/latest)** • **[🎮 View All Releases](https://github.com/tje3d/Headsup/releases)** • **[📖 Documentation](https://github.com/tje3d/Headsup/wiki)**

Made with ❤️ for the WoW community

</div>
