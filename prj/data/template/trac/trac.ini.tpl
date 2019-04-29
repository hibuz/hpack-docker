# -*- coding: utf-8 -*-

[header_logo]
alt = %PROJECT_NAME%
link = /trac/%PROJECT_NAME%

[inherit]
file = %HPACK_TEMPLATE%/trac/trac.ini

[project]
descr = %PROJECT_NAME% project
name = %PROJECT_NAME%
url = /trac/%PROJECT_NAME%

[trac]
authz_module_name = %PROJECT_NAME%
base_url = http://localhost/trac/%PROJECT_NAME%
repository_dir = %HPACK_PRJ_SVN%/%PROJECT_NAME%
