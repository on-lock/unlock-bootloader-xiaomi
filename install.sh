#!/bin/bash

# ===== COLOR CODES =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ===== ASCII ART =====
echo -e "${CYAN}${BOLD}"
echo "   ██████╗ ███╗   ██╗"
echo "  ██╔═══██╗████╗  ██║"
echo "  ██║   ██║██╔██╗ ██║"
echo "  ██║   ██║██║╚██╗██║"
echo "  ╚██████╔╝██║ ╚████║"
echo "   ╚═════╝ ╚═╝  ╚═══╝"
echo -e "${NC}"

echo -e "${CYAN}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║${NC}    ${WHITE}${BOLD}Mi Community Permission Tool${NC}    ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}╠══════════════════════════════════════╣${NC}"
echo -e "${CYAN}${BOLD}║  ${NC} ${YELLOW}Version:${NC} ${GREEN}1.5.3${NC}                   ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}║  ${NC} ${YELLOW}Developer:${NC} ${GREEN}@hacker_one_2${NC}           ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}\n"

# ===== CHECK PYTHON =====
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 not found! Installing...${NC}"
    pkg install python3 -y 2>/dev/null || apt install python3 -y 2>/dev/null
fi

# ===== CHECK PIP =====
if ! command -v pip &> /dev/null; then
    echo -e "${YELLOW}⚠️ Pip not found! Installing...${NC}"
    python3 -m ensurepip --upgrade 2>/dev/null
fi

# ===== INSTALL REQUIREMENTS =====
echo -e "${GREEN}📦 Installing required packages...${NC}"
pip install requests ntplib 2>/dev/null

# ===== CREATE HIDDEN FOLDER =====
echo -e "${GREEN}📁 Creating hidden folder ~/.onlock...${NC}"
mkdir -p ~/.onlock

# ===== DOWNLOAD MAIN SCRIPT =====
echo -e "${GREEN}📥 Downloading MiCommunityTool.py to ~/.onlock/...${NC}"
curl -sSL "https://raw.githubusercontent.com/on-lock/unlock-bootloader-xiaomi/main/MiCommunityTool.py" -o ~/.onlock/MiCommunityTool.py

# ===== CHECK IF DOWNLOAD SUCCEEDED =====
if [ ! -s ~/.onlock/MiCommunityTool.py ]; then
    echo -e "${RED}❌ Download failed! File is empty.${NC}"
    exit 1
fi

# ===== SET PERMISSIONS =====
chmod +x ~/.onlock/MiCommunityTool.py

# ===== CREATE EXECUTABLE SCRIPT IN TERMUX BIN =====
echo -e "${GREEN}🔧 Installing 'onlock' command...${NC}"

# Termux path
if [ -d "/data/data/com.termux/files/usr/bin" ]; then
    echo '#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"' > /data/data/com.termux/files/usr/bin/onlock
    chmod +x /data/data/com.termux/files/usr/bin/onlock
    echo -e "${GREEN}✅ Installed to Termux bin${NC}"
# Linux path
elif [ -d "/usr/local/bin" ]; then
    echo '#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"' > /usr/local/bin/onlock
    chmod +x /usr/local/bin/onlock
    echo -e "${GREEN}✅ Installed to /usr/local/bin${NC}"
else
    # Fallback
    echo 'export PATH="$HOME/.onlock:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.onlock:$PATH"' >> ~/.zshrc 2>/dev/null
    echo '#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"' > ~/.onlock/onlock
    chmod +x ~/.onlock/onlock
    export PATH="$HOME/.onlock:$PATH"
fi

# ===== COMPLETE =====
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${YELLOW}▶️ Type '${GREEN}onlock${YELLOW}' to start the tool.${NC}"
