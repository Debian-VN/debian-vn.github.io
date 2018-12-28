#!/usr/bin/env python
# -*- coding: utf-8 -*- #

# Basic details
AUTHOR = u'Debian Việt Nam'
SITENAME = u'Debian VN'
SITEURL = 'https://debian-vn.github.io'

# Configuration
TIMEZONE = 'Asia/Ho_Chi_Minh'
DEFAULT_LANG = u'vi'
DELETE_OUTPUT_DIRECTORY = False
THEME = "theme-debian-vn"
DEFAULT_PAGINATION = 5
DISPLAY_PAGES_ON_MENU = True
SUMMARY_MAX_LENGTH = 40
LOCALE='C'

# URL settings
# We might want this for publication
#RELATIVE_URLS = False
ARTICLE_URL = '{date:%Y}/{date:%m}/{slug}.html'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{slug}.html'
ARTICLE_LANG_URL = '{date:%Y}/{date:%m}/{slug}-{lang}.html'
ARTICLE_LANG_SAVE_AS = '{date:%Y}/{date:%m}/{slug}-{lang}.html'

# Feeds settings
FEED_DOMAIN = SITEURL
FEED_ATOM = 'feeds/atom.xml'
FEED_RSS = 'feeds/feed.rss'
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
CATEGORY_FEED_ATOM = None
CATEGORY_FEED_RSS = None
TAG_FEED_ATOM = None
TAG_FEED_RSS = None
TRANSLATION_FEED = None
TRANSLATION_FEED_ATOM = 'feeds/atom-%s.xml'
TRANSLATION_FEED_RSS = 'feeds/feed-%s.rss'


MENUITEMS =  (('Home', 'http://debian-vn.github.io'),)

LINKS = (('Bits from Debian', 'https://bits.debian.org/'),
          ('OS for Privacy','https://www.privacytools.io/#os'),
          ('#debian-vn IRC','https://webchat.oftc.net/?channels=%23debian-vn'))
DOCS = (('Debian New Maintainers\' Guide','https://debian-vn.github.io/maint-guide'),
        ('Installation Guide','https://www.debian.org/releases/stable/amd64/index.html.vi'))

PATH = 'content'
STATIC_PATHS = [
    'extras/favicon.ico',
	'images',
    ]
EXTRA_PATH_METADATA = {
    'extras/favicon.ico': {'path': 'favicon.ico'},
    }

# Plugins

PLUGINS = ["add_translator_line"]
PLUGIN_PATHS = ["plugins"]
