from trac.core import *
from trac.mimeview.api import IContentConverter
from trac.wiki.formatter import wiki_to_html
import os

class PageToHtmlPlugin(Component):
    """Convert Wiki pages to html."""
    implements(IContentConverter)

    # IContentConverter methods
    def get_supported_conversions(self):
        yield ('html', 'HTML', 'html', 'text/x-trac-wiki', 'application/html', 7)

    def convert_content(self, req, input_type, source, output_type):
        html = wiki_to_html(source, self.env, req)
	
	return (html, 'text/plain')
