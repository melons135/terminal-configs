# terminal-configs
Terminal configuration files in an easy to get repo
This repo should be downloaded to /usr/share/ then linked to config locations.

# Add the following to the mozilla faves [done]
MalwareBazaar - https://bazaar.abuse.ch/browse/
theZoo - https://github.com/ytisf/theZoo
VX-Underground - https://vx-underground.org/samples.html
Malpedia - https://malpedia.caad.fkie.fraunhofer.de/

# ToDo
- A number of files exitied on windows will need dos2unix conversion to remove ^M symbol when loading **[Expected Resolved]]**
- if terminal theme doesn't load properly at first then source the theme file, i think its an issues with load order of .zshrc **[Expected Resolved]]**
- add the following to mozilla: **[DONE]**
  - Extensions
    - https://github.com/zdhenard42/SOC-Multitool - https://addons.mozilla.org/en-US/firefox/addon/soc-multi-tool/
  -Bookmarks
    - https://osint.sh/
    - https://lobuhi.github.io/#
    - https://threatbook.io/
    - https://www.filescan.io/scan
    - https://opensourcesecurityindex.io/

# Migrating Firefox Profile
from https://support.mozilla.org/en-US/kb/back-and-restore-information-firefox-profiles # Restoring to a different location
> basically just copy contents of xxxxxxxx.default backup into new xxxxxxxx.default in the .mozilla/Firefox/Profiles folder

1) Locate the backed-up profile folder on your hard drive or backup medium (e.g., your USB stick).
2) Open the profile folder backup (e.g., the xxxxxxxx.default backup).
3) Copy the entire contents of the profile folder backup, such as the handlers.json file, prefs.js file, bookmarkbackups folder, etc.
4) Locate and open the new profile folder as explained above and then close Firefox (if open).
5) Paste the contents of the backed up profile folder into the new profile folder, overwriting existing files of the same name.
6) Start Firefox.

find $HOME/.mozilla/Firefox/Profiles -type d -name *.default -ls 2>/dev/null
