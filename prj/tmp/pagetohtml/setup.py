from setuptools import setup

PACKAGE = 'PageToHtml'
VERSION = '0.1'

setup(name=PACKAGE,
      version=VERSION,
      packages=['pagetohtml'],
      entry_points={'trac.plugins': '%s = pagetohtml' % PACKAGE},
      install_requires = ['setuptools'],
      # author metadata
      author = 'hibuz',
      author_email = 'hibuz@h i b u z.com',
      description = '',
      url = 'https://hibuz.com',

)

