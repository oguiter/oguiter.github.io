#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Olivier Guiter'
SITENAME = "Olivier's Tech Blog"

SITEURL = 'http://localhost:8000'
RELATIVE_URLS = False
SITESUBTITLE = 'Et pour quelques octets de plus...'
SITEDESCRIPTION = '%s\'s Thoughts and Writings' % AUTHOR
SITELOGO = 'img/logo_site.jpg'
#BROWSER_COLOR = '#333333'
#PYGMENTS_STYLE = 'monokai'

USE_FOLDER_AS_CATEGORY = False
MAIN_MENU = True
HOME_HIDE_TAGS = False

MENUITEMS = (('Archives', '/archives.html'),
             ('Categories', '/categories.html'),
             ('Tags', '/tags.html'),
             ('Sitemap', '/sitemap.xml'),
             ('About me', '/about.html'),)


#locale
TIMEZONE = 'Europe/Paris'
DEFAULT_LANG = 'fr'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Following items are often useful when publishing
#DISQUS_SITENAME = ""
GOOGLE_ANALYTICS = "UA-112326394-1"

# Blogroll
#LINKS = (('Pelican', 'http://getpelican.com/'),
#         ('Python.org', 'http://python.org/'),
#         ('Jinja2', 'http://jinja.pocoo.org/'),
#         ('You can modify those links in your config file', '#'),)

# Social widget
#SOCIAL = (('You can add links in your config file', '#'),
#          ('Another social link', '#'),)

SOCIAL = ( ('linkedin', 'https://www.linkedin.com/in/oguiter'),
          ('github', 'https://github.com/oguiter'),
 )

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True


MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {'css_class': 'highlight'},
        'markdown.extensions.extra': {},
        'markdown.extensions.meta': {},
    },
    'output_format': 'html5',
}

DELETE_OUTPUT_DIRECTORY = False
PATH = 'content'
STATIC_PATHS = ['img', 'static', 'pdf']
DEFAULT_METADATA = {
    'status': 'draft',
}

FAVICON = 'img/favicon.ico'
CUSTOM_CSS = 'static/custom.css'
PLUGIN_PATHS = ['/home/oguiter/Devel/GITHUB/Blog/pelican-extend/pelican-plugins/']

PLUGINS = ['sitemap']

SITEMAP = {
    'format': 'xml',
    'priorities': {
        'articles': 0.6,
        'indexes': 0.6,
        'pages': 0.5,
    },
    'changefreqs': {
        'articles': 'monthly',
        'indexes': 'daily',
        'pages': 'monthly',
    }
}


##THEME = 'pelican-striped-html5up'
##PLUGINS = ['neighbors']
# theme area..
THEME = "Flex"
# add theme specific vars

#Footer ---------------------------
CC_LICENSE = {
    'name': 'Creative Commons Attribution-ShareAlike',
    'version': '4.0',
    'slug': 'by-sa'
}

COPYRIGHT_NAME = AUTHOR
COPYRIGHT_YEAR = 2017
