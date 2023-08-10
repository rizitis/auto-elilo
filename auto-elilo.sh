#!/bin/bash

# Anagnostakis Ioannis GR Crete 8/2023
# Auto Elilo is a script after slackpkg upgrade-all upgrade system kernel 
# and me/you forgot to eliloconfig...
# In my case I use SBKS and always have a backup kernel in my system. (https://github.com/rizitis/SBKS) #
# But just in case....

# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# root
if [ "$EUID" -ne 0 ];then
echo "ROOT ACCESS PLEASE OR GO HOME..."
exit 1
fi

# if first time run auto-elilo then mkdir
dir=/usr/local/auto-elilo
file=/usr/local/auto-elilo/auto-elilo.TXT
file2=/usr/local/auto-elilo/auto-elilo.BAK

if [ -d "$dir" ]
then
echo "auto-elilo is installed"
else
mkdir -p "$dir"
/bin/ls -tr /var/log/pkgtools/removed_scripts/ | grep kernel | tail -4 > "$file"
echo "Looks like you are running auto-elilo for first time?"
exit
fi

cd "$dir" || exit

if [ -f /usr/local/auto-elilo/auto-elilo.TXT ]
then 
mv "$file" "$file2" || exit
else 
echo "************************************"
echo "Something went wrong, ATTENSION... *"
echo "************************************"
exit
fi

set -e

if [ -f "$file2" ]
then 
/bin/ls -tr /var/log/pkgtools/removed_scripts/ | grep kernel | tail -4 > "$file"
fi

if cmp -s auto-elilo.TXT auto-elilo.BAK ; then
echo "NO KERNEL UPDATE WAS FOUND"
sleep 2
else
echo "KERNEL WAS UPDATED, UPDATING ELILO..."
 eliloconfig
fi



