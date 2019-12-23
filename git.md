**GIT**

******** git [reference url git](https://git-scm.com/book/fr/v2/Utilitaires-Git-Stockage-des-identifiants#s_credential_caching "git")

```shell
sudo apt-get install git-all
git config --global user.name "Van Dravik"
git config --global user.email jan@vandravik.com
git config --list

git clone https://github.com/janvandan/nextcloud.git

git status

vi backup.sh
//
//

git add backup.sh

git status
git log

git remote -v
git remote show origin

git commit -m 'changement backup.sh 0.1'
git push origin master

git config --global credential.helper cache
git add backup.sh
git commit -m 'changement backup.sh 0.1'

git credential fill
//
host=github.com

//

cd
vi .gitconfig
//
helper = cache --timeout 30000
//
```
