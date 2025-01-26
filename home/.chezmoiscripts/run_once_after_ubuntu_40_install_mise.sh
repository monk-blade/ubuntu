#!/usr/bin/env -S bash

echo ""
echo "==============================================================="
echo ""
echo "Installing mise and tools managed by Mise"
echo ""
echo "==============================================================="
echo ""

wget -qO- https://mise.run/ | sh

mise install --yes 

echo ""
echo "==============================================================="
echo ""
echo "Installing starship prompt"
echo ""
echo "==============================================================="
echo ""


curl -sS https://starship.rs/install.sh | sh