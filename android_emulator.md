# Android Emulator Quick Reference

## Starting the Emulator

```bash
flutter emulators --launch Medium_Phone_API_36
```

Wait 30-60 seconds for boot, then press the power button if screen is black.

## Common Commands

```bash
# List available emulators
flutter emulators

# Check if emulator is running
flutter devices

# Kill emulator (if frozen)
adb emu kill
```

## VSCode Usage

1. Start emulator first (command above)
2. Wait for boot
3. Select "Android" from launch dropdown
4. Press F5

## Troubleshooting

- **Black screen**: Press power button on emulator
- **Not detected**: Wait longer or run `flutter devices` to check status
- **Frozen**: Close window or run `adb emu kill`

## Performance Tips

- Keep emulator running between sessions (don't close it)
- First boot is slow, subsequent boots are faster