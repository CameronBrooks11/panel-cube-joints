default:
    @just --list

# Render every example: no warnings, the box's parts on the bed, round screw holes, the tray's size
test:
    python3 tests/test_examples.py
