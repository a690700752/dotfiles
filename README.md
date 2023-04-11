# configs

includes spacevim like config for:

- neovim
- tmux
- nvchad
- kitty
- karabiner
- jb idea plugin

## gradle proxy

fix gradle download failed.

```sh
$ cat ~/.gradle/gradle.properties
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=7890
systemProp.http.nonProxyHosts=localhost
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=7890
systemProp.https.nonProxyHosts=localhost
```
