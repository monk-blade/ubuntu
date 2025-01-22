#!/usr/bin/env -S bash

echo ""
echo "==============================================================="
echo ""
echo "Installing mise and tools managed by Mise"
echo ""
echo "==============================================================="
echo ""

wget -qO- https://mise.run/ | sh

mise install --yes --global
