## Updated README for LuxR

# The Lux Empire RedM Framework

- **Discord:** https://discord.gg/Aj7KGKMDBU
- **GitHub:** https://github.com/iboss21
- **Tebex Store:** https://theluxempire.tebex.io/
- **The Lux RedM Framework:** https://github.com/The-Lux-Empire-Redm-Framework
- **The Lux Empire FiveM Project:** https://github.com/TheLuxEmpire-Success

# `luxr-bountyhunter`

A highly configurable bounty hunter script for the LuxR RedM Framework.

## Dependencies

- `luxr-core`
- `luxr-target`
- `ox_lib`

## Installation

1. **Ensure Dependencies**: Make sure all dependencies are added to your resources and started.
2. **Add Resource**: Place `luxr-bountyhunter` in your `resources` folder.
3. **Configure Script**:
   - Open `config.lua` and adjust settings to your preference.
   - All major configurations and messages are editable from this file.
4. **Start the Resource**:
   - Add the following to your `server.cfg` file:
     ```cfg
     ensure luxr-bountyhunter
     ```

## Configuration

The script is designed to be highly customizable:

- **General Settings**: Adjust maximum and minimum bounty amounts, notification durations, and job types that can manage bounties.
- **Bounty Board Models**: Specify which models serve as bounty boards.
- **Bounty Board Actions**: Customize the actions available on bounty boards, including labels, icons, and events.
- **Log Settings**: Enable or disable logging and customize log messages.
- **Messages**: All player-facing messages are configurable in the `locales/en.lua` file.

## Support

For support and further assistance, please join our [Discord](https://discord.gg/Aj7KGKMDBU) or visit our [GitHub](https://github.com/iboss21).

