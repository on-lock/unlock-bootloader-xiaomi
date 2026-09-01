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

# ===== CREATE EXECUTABLE SCRIPT =====
echo -e "${GREEN}🔧 Installing 'onlock' command...${NC}"

# Detect Termux
if [ -d "/data/data/com.termux/files/usr/bin" ]; then
    # Termux installation
    cat > /data/data/com.termux/files/usr/bin/onlock << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"
EOF
    chmod +x /data/data/com.termux/files/usr/bin/onlock
    echo -e "${GREEN}✅ Installed to Termux bin${NC}"
    
# Detect Linux
elif [ -d "/usr/local/bin" ]; then
    # Linux installation
    sudo cat > /usr/local/bin/onlock << 'EOF'
#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"
EOF
    sudo chmod +x /usr/local/bin/onlock
    echo -e "${GREEN}✅ Installed to /usr/local/bin${NC}"
    
else
    # Fallback: install to ~/.onlock and add to PATH
    echo -e "${YELLOW}⚠️ No standard bin directory found. Adding to PATH...${NC}"
    
    # Create wrapper script
    cat > ~/.onlock/onlock << 'EOF'
#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py "$@"
EOF
    chmod +x ~/.onlock/onlock
    
    # Add to PATH in shell configs
    if [ -f ~/.bashrc ]; then
        if ! grep -q "export PATH=\"\$HOME/.onlock:\$PATH\"" ~/.bashrc; then
            echo 'export PATH="$HOME/.onlock:$PATH"' >> ~/.bashrc
        fi
    fi
    
    if [ -f ~/.zshrc ]; then
        if ! grep -q "export PATH=\"\$HOME/.onlock:\$PATH\"" ~/.zshrc; then
            echo 'export PATH="$HOME/.onlock:$PATH"' >> ~/.zshrc
        fi
    fi
    
    # Export for current session
    export PATH="$HOME/.onlock:$PATH"
    
    echo -e "${GREEN}✅ Installed to ~/.onlock/onlock${NC}"
    echo -e "${YELLOW}⚠️ Please restart your terminal or run: source ~/.bashrc${NC}"
fi

# ===== CREATE ALIAS FOR EASY ACCESS =====
if [ -f ~/.bashrc ]; then
    if ! grep -q "alias onlock=" ~/.bashrc; then
        echo 'alias onlock="python3 ~/.onlock/MiCommunityTool.py"' >> ~/.bashrc
    fi
fi

if [ -f ~/.zshrc ]; then
    if ! grep -q "alias onlock=" ~/.zshrc; then
        echo 'alias onlock="python3 ~/.onlock/MiCommunityTool.py"' >> ~/.zshrc
    fi
fi

# ===== TEST THE INSTALLATION =====
echo -e "${GREEN}🧪 Testing installation...${NC}"
if command -v onlock &> /dev/null; then
    echo -e "${GREEN}✅ 'onlock' command is available!${NC}"
else
    echo -e "${YELLOW}⚠️ 'onlock' not found in PATH. Trying alternative method...${NC}"
    
    # Create a direct alias in current session
    alias onlock="python3 ~/.onlock/MiCommunityTool.py"
    
    # Source the config files
    if [ -f ~/.bashrc ]; then
        source ~/.bashrc 2>/dev/null
    fi
    if [ -f ~/.zshrc ]; then
        source ~/.zshrc 2>/dev/null
    fi
    
    echo -e "${YELLOW}💡 You can now use: ${GREEN}python3 ~/.onlock/MiCommunityTool.py${NC}"
    echo -e "${YELLOW}💡 Or add this alias manually: ${GREEN}alias onlock='python3 ~/.onlock/MiCommunityTool.py'${NC}"
fi

# ===== COMPLETE =====
echo -e "\n${GREEN}✅ Installation complete!${NC}"
echo -e "${YELLOW}▶️ Type '${GREEN}onlock${YELLOW}' to start the tool.${NC}"
echo -e "${YELLOW}⚠️ If 'onlock' doesn't work, run: ${GREEN}source ~/.bashrc${NC} ${YELLOW}or restart the terminal${NC}"

# ===== AUTO-START (Optional) =====
echo -e "\n${CYAN}${BOLD}Do you want to run the tool now?${NC}"
echo -e "${YELLOW}1) ${GREEN}Yes, run now${NC}"
echo -e "${YELLOW}2) ${RED}No, exit${NC}"
read -p "Choice [1/2]: " choice

if [ "$choice" = "1" ] || [ -z "$choice" ]; then
    echo -e "\n${GREEN}🚀 Starting Mi Community Tool...${NC}\n"
    python3 ~/.onlock/MiCommunityTool.py
else
    echo -e "${GREEN}✅ Setup complete! Run 'onlock' anytime to start.${NC}"
    exit 0
fi
