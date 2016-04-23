"""
This plugin add the `translator` value to the article
"""

from pelican import signals

def add_translator_line(generator):

    for article in generator.articles:
        if hasattr(article,'translator'):
            translator = article.translator

def register():
    signals.article_generator_finalized.connect(add_translator_line)
