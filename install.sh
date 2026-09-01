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
echo -e "${CYAN}${BOLD}║${NC}    ${WHITE}${BOLD}Onlock Installer${NC}              ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}╠══════════════════════════════════════╣${NC}"
echo -e "${CYAN}${BOLD}║  ${NC} ${YELLOW}Version:${NC} ${GREEN}1.0${NC}                       ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}║  ${NC} ${YELLOW}Developer:${NC} ${GREEN}@hacker_one_2${NC}           ${CYAN}${BOLD}║${NC}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════╝${NC}\n"

# ===== CHECK PYTHON =====
echo -e "${YELLOW}🔍 Checking Python installation...${NC}"

PYTHON_INSTALLED=false

if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✅ Python3 is already installed: $(python3 --version)${NC}"
    PYTHON_INSTALLED=true
else
    echo -e "${RED}❌ Python3 not found!${NC}"
    echo -e "${YELLOW}📦 Installing Python3...${NC}"
    
    # Try pkg (Termux)
    if command -v pkg &> /dev/null; then
        pkg install python3 -y
    # Try apt (Linux)
    elif command -v apt &> /dev/null; then
        apt update -y
        apt install python3 python3-pip -y
    # Try yum (RHEL)
    elif command -v yum &> /dev/null; then
        yum install python3 python3-pip -y
    else
        echo -e "${RED}❌ Could not install Python3. Please install manually.${NC}"
        exit 1
    fi
    
    # Check again after installation
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}✅ Python3 installed successfully: $(python3 --version)${NC}"
        PYTHON_INSTALLED=true
    else
        echo -e "${RED}❌ Python3 installation failed!${NC}"
        exit 1
    fi
fi

# ===== CHECK PIP (only if Python was just installed or not present) =====
if [ "$PYTHON_INSTALLED" = true ]; then
    echo -e "${YELLOW}🔍 Checking pip...${NC}"
    if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
        echo -e "${YELLOW}📦 Installing pip...${NC}"
        python3 -m ensurepip --upgrade 2>/dev/null || python3 -m pip install --upgrade pip 2>/dev/null
    fi
    
    if command -v pip &> /dev/null || command -v pip3 &> /dev/null; then
        echo -e "${GREEN}✅ pip is available${NC}"
    fi
fi

# ===== INSTALL REQUIRED PACKAGES (only if needed) =====
echo -e "${YELLOW}📦 Checking required Python packages...${NC}"

# Check if packages are already installed
if python3 -c "import requests, ntplib" 2>/dev/null; then
    echo -e "${GREEN}✅ Required packages already installed!${NC}"
else
    echo -e "${YELLOW}📦 Installing requests and ntplib...${NC}"
    pip install requests ntplib 2>/dev/null || python3 -m pip install requests ntplib 2>/dev/null
    echo -e "${GREEN}✅ Packages installed!${NC}"
fi

# ===== CREATE HIDDEN FOLDER =====
echo -e "${YELLOW}📁 Creating directory ~/.onlock...${NC}"
mkdir -p ~/.onlock

# ===== DOWNLOAD MAIN SCRIPT =====
echo -e "${YELLOW}📥 Downloading MiCommunityTool.py...${NC}"
curl -sSL "https://raw.githubusercontent.com/on-lock/unlock-bootloader-xiaomi/main/MiCommunityTool.py" -o ~/.onlock/MiCommunityTool.py

# ===== CHECK DOWNLOAD =====
if [ ! -s ~/.onlock/MiCommunityTool.py ]; then
    echo -e "${RED}❌ Download failed! File is empty.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Script downloaded successfully!${NC}"

# ===== SET PERMISSIONS =====
chmod +x ~/.onlock/MiCommunityTool.py

# ===== INSTALL onlock COMMAND =====
echo -e "${YELLOW}🔧 Installing 'onlock' command...${NC}"

# Detect Termux
if [ -d "/data/data/com.termux/files/usr/bin" ]; then
    # Termux installation
    cat > /data/data/com.termux/files/usr/bin/onlock << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
python3 ~/.onlock/MiCommunityTool.py
EOF
    chmod +x /data/data/com.termux/files/usr/bin/onlock
    echo -e "${GREEN}✅ Installed to Termux bin${NC}"
    
# Detect Linux
elif [ -d "/usr/local/bin" ]; then
    # Linux installation (with sudo if needed)
    if [ -w "/usr/local/bin" ]; then
        cat > /usr/local/bin/onlock << 'EOF'
#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py
EOF
        chmod +x /usr/local/bin/onlock
    else
        sudo cat > /usr/local/bin/onlock << 'EOF'
#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py
EOF
        sudo chmod +x /usr/local/bin/onlock
    fi
    echo -e "${GREEN}✅ Installed to /usr/local/bin${NC}"
    
else
    # Fallback: install to ~/.onlock and add to PATH
    echo -e "${YELLOW}⚠️ No standard bin directory found. Adding to PATH...${NC}"
    
    cat > ~/.onlock/onlock << 'EOF'
#!/bin/bash
python3 ~/.onlock/MiCommunityTool.py
EOF
    chmod +x ~/.onlock/onlock
    
    # Add to PATH
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
fi

# ===== CREATE ALIAS (backup) =====
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

# ===== VERIFY INSTALLATION =====
echo -e "${YELLOW}🧪 Verifying installation...${NC}"

# Source config files
[ -f ~/.bashrc ] && source ~/.bashrc 2>/dev/null
[ -f ~/.zshrc ] && source ~/.zshrc 2>/dev/null

# Check if onlock command exists
if command -v onlock &> /dev/null; then
    echo -e "${GREEN}✅ 'onlock' command is ready!${NC}"
else
    echo -e "${YELLOW}⚠️ Command not found in PATH. Using fallback method...${NC}"
    echo -e "${GREEN}✅ You can run: ${CYAN}python3 ~/.onlock/MiCommunityTool.py${NC}"
fi

# ===== COMPLETE =====
echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║     ✅ INSTALLATION COMPLETE!       ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════╝${NC}\n"

echo -e "${CYAN}${BOLD}📌 How to use:${NC}"
echo -e "   ${GREEN}1.${NC} Type ${BOLD}${WHITE}onlock${NC} in your terminal"
echo -e "   ${GREEN}2.${NC} Enter your Telegram User ID when prompted"
echo -e "   ${GREEN}3.${NC} Follow the instructions on screen\n"

echo -e "${YELLOW}💡 Tip:${NC} If 'onlock' doesn't work, run:"
echo -e "   ${WHITE}source ~/.bashrc${NC} or ${WHITE}source ~/.zshrc${NC}"
echo -e "   Or simply restart your terminal\n"

echo -e "${GREEN}✅ Done! Run 'onlock' to start the tool.${NC}"
