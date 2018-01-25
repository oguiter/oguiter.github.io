Title: Installation d'un blog statique sous Pelican
Status: published
Date: 2018-01-21 14:00
Modified: 2018-01-21 14:10
Category: General
Tags: #pelican, #blog

Dans ce premier article, j'aimerais vous expliquer comment installer un blog statique tel que ... celui ci !

Mes critéres initiaux étaient simples:

- Maintenance minimale,
- Integration avec [github.io](https://pages.github.com/)
- Python ou Php
- Markdown pour les articles
- Commentaires

Après avoir regardé differentes options ( [Jekyll](jekyllrb.com), [Sculpin](sculpin.io), j'ai opté pour [pelican](getpelican.com)

### <font color=#669900>*Un repo GitHub pour votre blog*</font>

Il s'agit pour moi de créer ma page perso dans GitHub. J'ai donc commencé par créer un repo [oguiter.github.io](oguiter.github.io), ``oguiter`` étant mon nom de compte GitHub. Le source complet est là: [https://github.com/oguiter/oguiter.github.io/](https://github.com/oguiter/oguiter.github.io/).


### <font color=#669900>*Installation Pelican*</font>

Personnellement, j'ai opté pour l'utilisation de ``virtualenv`` sous python. Cela va isoler votre developpement un peu (j'ai dis "un peu") dans l'esprit Docker... Cette notion d' *environnement virtuel* va permettre la creation d'un dossier séparé avec toute la cuisine python ainsi que les *site-packages*. Un peu plus d'infos là: [virtualenv site](https://virtualenv.pypa.io/en/stable/)

C'est parti !

```sh
pip install virtualenv
cd mkdir -p ~/Devel/monblog
cd ~/Devel/monblog
virtualenv env
```

Tout est prêt, il ne reste qu'à activer l'environnement virtuel

```sh
source env/bin/activate
```

Une petit vérification s'impose concernant notre ``nouveau`` binaire python

```sh
$which python
(env) [10:56][oguiter:~]$ which python
/home/oguiter/test2/bin/python
```

<img
src="/img/icon-green-check.png" width="20">
Remarque: Vous pouvez spécifier une version particuliere de python avec la commande:

```sh
virtualenv -p /usr/bin/python2.7 env27
```

Il est temps d'installer ``pelican`` (et ``Mardown`` bien sûr !)

```sh
pip install pelican
pip install Markdown
```

### <font color=#669900>*Un petit blog ?*</font>

On va s'appuyer sur le modéle par defaut, puis nous essayerons de le faire évoluer...

Commençons par lancer le wizard de service:

```sh
cd ~/Devel/monblog
pelican-quickstart
```

Bon, il faut répondre quand même à quelques questions (il ne peut pas tout faire tout seul, hein ?!)

```sh
(env) [14:18][oguiter:~/Devel/GITHUB/Blog]$ pelican-quickstart 
Welcome to pelican-quickstart v3.7.1.

This script will help you create a new Pelican-based website.

Please answer the following questions so this script can generate the files
needed by Pelican.

> Where do you want to create your new web site? [.] .
> What will be the title of this web site? Mon Blog
> Who will be the author of this web site? Olivier Guiter
> What will be the default language of this web site? [en] fr
> Do you want to specify a URL prefix? e.g., http://example.com   (Y/n) Y
> What is your URL prefix? (see above example; no trailing slash) http://username.github.io 
> Do you want to enable article pagination? (Y/n) Y
> How many articles per page do you want? [10] 
> What is your time zone? [Europe/Paris] 
> Do you want to generate a Fabfile/Makefile to automate generation and publishing? (Y/n) Y
> Do you want an auto-reload & simpleHTTP script to assist with theme and site development? (Y/n) Y
> Do you want to upload your website using FTP? (y/N) N
> Do you want to upload your website using SSH? (y/N) N
> Do you want to upload your website using Dropbox? (y/N) N
> Do you want to upload your website using S3? (y/N) N
> Do you want to upload your website using Rackspace Cloud Files? (y/N) N
> Do you want to upload your website using GitHub Pages? (y/N) Y
> Is this your personal page (username.github.io)? (y/N) Y
Done. Your new project is available at /home/oguiter/Devel/GITHUB/Blog
```

(je rappelle que l'objectif est de mettre en place un blog sous GitHub...)

### <font color=#669900>*Le premier post ?*</font>

Une fois la structure en place, profitons-en pour créer notre premier post.

```sh
cd ~/monblog
nano lepremier.md
```

et créez le premier post:

```
Title: Mon premier Article
Date: 2018-01-22 12:00
Category: Blog
Tags: #blog, #test, #general

Ceci est mon 1er port ou article :-)
```

Il est temps de vérifier tout ceci, en generant les pages du site (qui seront générées dans le repertoire ``output``)

```sh
make html
```

### <font color=#669900>*Test en local*</font>

Nous utilisons pour ça le serveur interne de ``pelican``:
```sh
cd ~/monblog
make serve
```
Et vous pouvez ouvrir l'adresse http://localhost:8000/ dans votre navigateur habituel.


### <font color=#669900>*Publier votre site... to the world !*</font>

J'ai choisi de ne mettre dans mon repo username.github.io QUE les pages relatives au site et je sauve les sources dans un autre repo.
Donc, même cela semble un peu plus complexe, on gange en lisibilité et efficacité.
Nous allons utiliser ```ghp-import``` qui va nous permettre de transferer le repertoire output dans son propore repo.

```sh
pip install ghp-import
```

On va utiliser le .gitignore disponible ici https://github.com/getpelican/pelican-blog/blob/master/.gitignore
on crée le repo local

```sh
git init
```

On se connecte au repo remote:

```sh
git remote add origin https://github.com/username/username.github.io.git
git remote -v
```

Et on crée une branche spécifique à mes publications...

```sh
git checkout -b mon_blog
```

Il est temps de déployer le blog !
2 possibilités:

- on a fait des modifications sur les sources:

```sh
git add .
git commit -a -m "Mon message de commit"
git push -u origin mon_blog
```

- on a créé/modifié un ou des articles:

```sh
make html
ghp-import output -r origin -b master
git push origin master
git checkout mon_blog
```

### <font color=#669900>*Conclusion*</font>

Il s'agit là d'un premier article, fortement inspiré de plusieurs pages differentes, où j'ai essayé d'apporter ma touche personnelle.
La forme et le fond de cette page vont encore évoluer, il y a pas mal de choses à faire...

Olivier