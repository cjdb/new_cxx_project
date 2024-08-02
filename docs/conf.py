# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'new_cxx_project'
author = 'Christopher Di Bella'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'myst_parser',
    'sphinx.ext.autosectionlabel',
    'sphinx.ext.extlinks',
    'sphinx.ext.mathjax',
    'sphinx.ext.todo',
    'sphinx.ext.viewcode',
]

templates_path = ['_templates']
exclude_patterns = []

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_book_theme'
html_theme_options = {
    'repository_url': 'https://github.com/cjdb/new_cxx_project',
    'use_repository_button': True,
}
html_static_path = ['_static']
html_show_copyright = False

myst_enable_extensions = [
    'dollarmath',
    'amsmath',
    'deflist',
    'fieldlist',
    'html_admonition',
    'html_image',
    'colon_fence',
    'smartquotes',
    'replacements',
    'strikethrough',
    'substitution',
    'tasklist',
    'attrs_inline',
    'attrs_block',
]
