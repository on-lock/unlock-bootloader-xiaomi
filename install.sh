#!/bin/bash

# ===== COLOR CODES =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

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
    pkg install python3 -y 2>/dev/null || apt install python3 -y 2>/dev/null || echo -e "${RED}❌ Please install Python3 manually${NC}"
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

# ===== DOWNLOAD MAIN SCRIPT TO HIDDEN FOLDER =====
echo -e "${GREEN}📥 Downloading MiCommunityTool.py to ~/.onlock/...${NC}"
curl -sSL "https://raw.githubusercontent.com/YOUR_USERNAME/MiCommunityPermissionTool/main/MiCommunityTool.py" -o ~/.onlock/MiCommunityTool.py

# ===== SET PERMISSIONS =====
chmod +x ~/.onlock/MiCommunityTool.py

# ===== CREATE ALIAS =====
echo -e "${GREEN}🔧 Creating 'unlock' command...${NC}"

# برای bash
if [ -f ~/.bashrc ]; then
    if ! grep -q "alias unlock=" ~/.bashrc; then
        echo "alias unlock='python3 ~/.onlock/MiCommunityTool.py'" >> ~/.bashrc
    fi
fi

# برای zsh
if [ -f ~/.zshrc ]; then
    if ! grep -q "alias unlock=" ~/.zshrc; then
        echo "alias unlock='python3 ~/.onlock/MiCommunityTool.py'" >> ~/.zshrc
    fi
fi

# برای termux
if [ -f ~/.bashrc ]; then
    if ! grep -q "alias unlock=" ~/.bashrc; then
        echo "alias unlock='python3 ~/.onlock/MiCommunityTool.py'" >> ~/.bashrc
    fi
fi

# ===== RELOAD SHELL =====
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${YELLOW}ℹ️ Hidden folder created: ${GREEN}~/.onlock/${NC}"
echo -e "${YELLOW}ℹ️ Script location: ${GREEN}~/.onlock/MiCommunityTool.py${NC}"
echo -e "${YELLOW}ℹ️ Run '${GREEN}unlock${YELLOW}' to start the tool${NC}"
echo -e "${YELLOW}ℹ️ Or run: ${GREEN}python3 ~/.onlock/MiCommunityTool.py${NC}"

# ===== RELOAD ALIAS =====
source ~/.bashrc 2>/dev/null || source ~/.zshrc 2>/dev/null

# ===== RUN SCRIPT =====
echo -e "\n${GREEN}🚀 Starting MiCommunityTool...${NC}"
python3 ~/.onlock/MiCommunityTool.py