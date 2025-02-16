#!/usr/bin/env bash

# Define the root filesystem path and binary locations
ROOTFS="$PREFIX/var/lib/proot-distro/installed-rootfs" 
bin="$PREFIX/bin/ollama"
Ollama="$ROOTFS/ollama"

# Define color codes for terminal output
red="\e[31m" green="\e[32m" yellow="\e[33m"
blue="\e[34m" pink="\e[35m" cyan="\e[36m"
white="\e[37m" black="\e[30m" reset="\e[0m\n"
filred="\e[41;1m" boldw="\e[0;1m" dimw="\e[37;2m"

# Print the welcome message with ASCII art
printf "${boldw}${green}
 _______  ___      ___      _______  __   __  _______ 
|       ||   |    |   |    |   _   ||  |_|  ||   _   |
|   _   ||   |    |   |    |  |_|  ||       ||  |_|  |
|  | |  ||   |    |   |    |       ||       ||       |
|  |_|  ||   |___ |   |___ |       ||       ||       |
|       ||       ||       ||   _   || ||_|| ||   _   |
|_______||_______||_______||__| |__||_|   |_||__| |__|
                                                 In Termux
${yellow}                    Proot version
${red}         ** Run LLM locally on your Android **
${reset}
[+] You're Going to install ollama....
"

# Check if proot-distro is installed, if not, install it
if ! hash proot-distro > /dev/null 2>&1; then
  printf "${cyan}Installing proot-distro...${reset}"
  apt install proot-distro -y
fi

# Check if the Ollama directory exists
if [[ -d $Ollama ]]; then
  printf "${red}Existing ollama found, ${green}resetting...${reset}"
  # Reset Ollama installation
  pd reset ollama
elif [[ -d $ROOTFS/debian ]]; then 
  printf "${cyan}Existing debian found, backing up...${reset}"
  # Backup existing Debian installation
  mv $ROOTFS/debian $ROOTFS/debian.bak
  # Install Debian and rename it to Ollama
  pd install debian 
  pd rename debian ollama 
  printf "${green}Restoring debian...${reset}"
  # Restore the backed-up Debian installation
  mv $ROOTFS/debian.bak $ROOTFS/debian
else
  # Install Debian and rename it to Ollama
  pd install debian 
  pd rename debian ollama
fi

# Backup the existing .bashrc file
mv $Ollama/root/.bashrc $Ollama/root/.bashrc.bak

# Create a new .bashrc file for the Ollama environment
cat > $Ollama/root/.bashrc <<- EOM
apt update -y
curl -fsSL https://ollama.com/install.sh | sh 
mv .bashrc.bak .bashrc 
exit
EOM

# Print message about updating apt cache and installing Ollama
printf "${red}Updating apt cache and Installing ollama${reset}"
# Log into the Ollama environment
pd login ollama

# Create the executable script for Ollama
cat > $bin <<- EOF
#!/usr/bin/env bash
ollamaDir="\$PREFIX/var/lib/proot-distro/installed-rootfs/ollama"
unset LD_PRELOAD
args="\$@"
cmmd="ollama \$args"

# Execute the command within the Proot environment
exec proot --link2symlink -0 -r \$ollamaDir -b /dev/ -b /sys/ -b /proc/ -b /sdcard -b /storage -b \${HOME} -b \${TMPDIR} -b \${PREFIX}/share -w \$HOME /usr/bin/env HOME=\$HOME PREFIX=/usr SHELL=/bin/sh TERM="\$TERM" LANG=\$LANG PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/local/bin LD_LIBRARY_PATH=/usr/lib /bin/sh -c "\$cmmd"
EOF

# Set executable permissions for the binary
chmod 700 $bin 

# Print completion messages with instructions
printf "
${cyan} Ollama installed successfully
${yellow} execute ${green}ollama -h ${yellow} to run it ${reset}
${red} NOTE - ${cyan} This is a proot version of ollama; if any errors occur, please report issues at: 
${dimw}https://github.com/Anon4You/ollama-in-termux${reset}
${yellow} By Alienkrishn ${boldw}[Anon4You]
${boldw} Telegram: ${blue}https://t.me/nullxvoid${reset}
"
