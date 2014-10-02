name             'keboola-apache2'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures keboola-apache2'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'


depends 'apache2', '~> 2.0.0'
depends 'aws', '~> 2.4.0'